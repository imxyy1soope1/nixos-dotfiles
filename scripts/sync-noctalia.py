#!/usr/bin/env python3
"""Fold noctalia GUI overrides back into the declarative dotfiles config.

This script folds `noctalia config export merged` back into the per-aspect
*.toml files so the repo alone reproduces the current effective config:

  * export values win (added if missing, updated if changed),
  * repo-only keys and empty-table declarations are never deleted,
  * f32 serialization noise (0.74999998696148396 vs 0.75) is ignored,
  * floats are written back clean (0.8400000000000001 -> 0.84),
  * comments (tombi directives) are preserved across the rewrite.

Files are parsed with `tomli` and rewritten with `tomli_w`, then touched
files are re-formatted with `tombi` to match repo style. Note that `tomli_w`
renders every non-empty array on multiple lines and `tombi` preserves that
layout, so arrays in a folded file are reflowed from inline to multiline the
first time that file is touched.

After a successful fold the GUI override file is moved to
<state-dir>/settings.bak.d/<timestamp>.toml (the 3 most recent are kept) and
the running instance is reloaded.

Usage:
  sync-noctalia.py                       # preview the fold; change nothing
  sync-noctalia.py --apply               # apply, backup settings.toml, reload
  sync-noctalia.py --export-file <file>  # read the export from F instead of noctalia
  sync-noctalia.py --config-dir <dir>    # target a different config dir
  sync-noctalia.py --state-dir <dir>     # state dir holding settings.toml
"""

import argparse
import math
import os
import re
import shutil
import subprocess
import sys
from datetime import datetime, timezone
from pathlib import Path
from subprocess import CalledProcessError

import tomli
import tomli_w

REPO = Path(__file__).resolve().parent.parent
DEFAULT_CONFIG_DIR = REPO / "modules" / "desktop" / "wm" / "niri" / "noctalia"
DEFAULT_STATE_DIR = Path.home() / ".local" / "state" / "noctalia"
KEEP_BACKUPS = 3
FLOAT_TOL = 1e-4
FLOAT_PRECISION = 6


def parse_export(export_file: Path | None) -> dict:
    if export_file:
        return tomli.loads(export_file.read_text())
    try:
        proc = subprocess.run(
            ["noctalia", "config", "export", "merged"],
            capture_output=True,
            text=True,
            check=True,
        )
    except FileNotFoundError:
        sys.exit("error: `noctalia` not found on PATH")
    except CalledProcessError as err:
        sys.exit(f"error: `noctalia config export merged` failed:\n{err.stderr}")
    return tomli.loads(proc.stdout)


def values_differ(a, b) -> bool:
    """True if two values differ as config values (float-tolerant, recursive)."""
    if isinstance(a, (int, float)) and isinstance(b, (int, float)):
        return not math.isclose(float(a), float(b), rel_tol=0.0, abs_tol=FLOAT_TOL)
    if isinstance(a, list) and isinstance(b, list):
        return len(a) != len(b) or any(values_differ(x, y) for x, y in zip(a, b))
    if isinstance(a, dict) and isinstance(b, dict):
        return set(a) != set(b) or any(values_differ(a[k], b[k]) for k in a)
    return a != b


def collect_changes(repo_sub, exp_sub, prefix, changes):
    """Recursively diff export subtree against repo subtree, appending
    (path, old_value, new_value) tuples. New subtrees carry old_value=None
    and a dict new_value."""
    for k, v in exp_sub.items():
        path = prefix + [k]
        if isinstance(v, dict):
            cur = repo_sub.get(k)
            if isinstance(cur, dict):
                collect_changes(cur, v, path, changes)
            else:
                changes.append((path, cur, v))
        else:
            cur = repo_sub.get(k)
            if cur is None or values_differ(cur, v):
                changes.append((path, cur, v))


def clean_value(v):
    """Round floats to FLOAT_PRECISION places, recursively.

    tomli_w serialises floats with str(), which would keep f32 noise like
    0.74999998696148396 written by a float slider; rounding keeps written
    values clean without losing precision we care about.
    """
    if isinstance(v, float):
        return round(v, FLOAT_PRECISION)
    if isinstance(v, list):
        return [clean_value(x) for x in v]
    if isinstance(v, dict):
        return {k: clean_value(x) for k, x in v.items()}
    return v


# Preview rendering (display only; file I/O goes through tomli_w)


def _dotted(segments) -> str:
    """Render segments as a TOML dotted path, quoting non-bare segments."""
    out = []
    for s in segments:
        if not s or not all(c.isalnum() or c in "_-" for c in s):
            out.append('"' + s.replace("\\", "\\\\").replace('"', '\\"') + '"')
        else:
            out.append(s)
    return ".".join(out)


def _clean_float(v: float) -> str:
    s = f"{v:.6f}".rstrip("0").rstrip(".")
    return s + ".0" if "." not in s else s


def serialize_value(v, indent: str = "") -> str:
    if isinstance(v, bool):
        return "true" if v else "false"
    if isinstance(v, int):
        return str(v)
    if isinstance(v, float):
        return _clean_float(v)
    if isinstance(v, str):
        return '"' + v.replace("\\", "\\\\").replace('"', '\\"') + '"'
    if isinstance(v, list):
        return "[" + ", ".join(serialize_value(e, indent) for e in v) + "]"
    if isinstance(v, dict):
        inner = ", ".join(
            f"{_dotted([k])} = {serialize_value(x, '')}" for k, x in v.items()
        )
        return "{ " + inner + " }"
    raise TypeError(f"unsupported TOML value: {v!r}")


def serialize_subtree(path, subtree) -> str:
    """Serialize a dict as a TOML section block: headers followed by keys."""
    out = []

    def walk(p, d):
        out.append(f"[{_dotted(p)}]\n")
        for k, v in d.items():
            if not isinstance(v, dict):
                out.append(f"{k} = {serialize_value(v)}\n")
        for k, v in d.items():
            if isinstance(v, dict):
                walk(p + [k], v)

    walk(path, subtree)
    return "".join(out)


# Comment preservation


def extract_comment_blocks(text: str) -> list[tuple[list[str], str | None]]:
    """Contiguous comment lines, each paired with the table header that follows
    them (or None for a trailing run). tomli_w drops comments when rewriting a
    file, so they are re-anchored from the original text."""
    lines = text.splitlines()
    runs = []
    i = 0
    while i < len(lines):
        if lines[i].lstrip().startswith("#"):
            j = i
            while j < len(lines) and lines[j].lstrip().startswith("#"):
                j += 1
            runs.append((i, j))
            i = j
        else:
            i += 1
    blocks = []
    for start, end in runs:
        anchor = None
        for k in range(end, len(lines)):
            t = lines[k].strip()
            if t.startswith("[") and t.endswith("]"):
                anchor = t
                break
        blocks.append((lines[start:end], anchor))
    return blocks


def restore_comments(original_text: str, rendered_text: str) -> str:
    """Re-insert the original file's comments into tomli_w's output, before the
    table header each comment preceded (any stragglers go at EOF)."""
    blocks = extract_comment_blocks(original_text)
    if not blocks:
        return rendered_text
    pending = list(blocks)
    out = []
    for line in rendered_text.splitlines():
        stripped = line.strip()
        if stripped.startswith("[") and stripped.endswith("]"):
            for block, anchor in list(pending):
                if anchor == stripped:
                    out.extend(block)
                    pending.remove((block, anchor))
        out.append(line)
    for block, _anchor in pending:
        out.extend(block)
    return "\n".join(out) + "\n"


# Dict-based edits


def apply_path(data: dict, path, value, *, as_table: bool, old):
    """Set ``path`` to ``value`` in ``data``, creating intermediate tables.

    Leaf values are assigned in place (a new key appends at the end of its
    table). Sub-tables are inserted at their sorted position among sibling
    sub-tables, matching the repo's alphabetical `[section]` order; a scalar
    being replaced by a table is dropped first.
    """
    node = data
    for seg in path[:-1]:
        nxt = node.get(seg)
        if not isinstance(nxt, dict):
            nxt = {}
            node[seg] = nxt
        node = nxt
    key = path[-1]
    if as_table:
        if old is not None:
            node.pop(key, None)
        items = list(node.items())
        pos = len(items)
        for i, (k, v) in enumerate(items):
            if isinstance(v, dict) and k > key:
                pos = i
                break
        items.insert(pos, (key, value))
        node.clear()
        node.update(items)
    else:
        node[key] = value


# Verification and state handling


def completeness_diffs(export, repo_after) -> list:
    """Leaf paths where repo_after still differs from the export."""
    diffs = []

    def walk(e, r, prefix):
        for k, v in e.items():
            p = prefix + [k]
            if isinstance(v, dict):
                if not isinstance(r.get(k), dict):
                    diffs.append((p, None, v))
                else:
                    walk(v, r[k], p)
            else:
                cur = r.get(k)
                if cur is None or values_differ(cur, v):
                    diffs.append((p, cur, v))

    walk(export, repo_after, [])
    return diffs


def run_validate(config_dir: Path) -> bool:
    print(f"  validate: noctalia config validate {config_dir}")
    proc = subprocess.run(
        ["noctalia", "config", "validate", str(config_dir)],
        capture_output=True,
        text=True,
        check=False,
    )
    out = proc.stdout + proc.stderr
    for line in out.splitlines():
        print(f"    {line}")
    if "WARN" in out:
        print(
            "    note: confirm none of the warnings above were newly introduced by this fold"
        )
    return proc.returncode == 0


def run_tombi(files) -> None:
    for f in files:
        proc = subprocess.run(
            ["tombi", "format", str(f)], capture_output=True, text=True, check=False
        )
        if proc.returncode != 0:
            print(f"    tombi format {f.name}: FAILED\n{proc.stdout}{proc.stderr}")


def backup_settings(state_dir: Path, keep: int = KEEP_BACKUPS):
    src = state_dir / "settings.toml"
    if not src.exists():
        return None
    bak = state_dir / "settings.bak.d"
    bak.mkdir(parents=True, exist_ok=True)
    ts = datetime.now(timezone.utc).strftime("%Y%m%d-%H%M%S")
    dest = bak / f"{ts}.toml"
    n = 1
    while dest.exists():
        dest = bak / f"{ts}-{n}.toml"
        n += 1
    shutil.move(str(src), str(dest))
    # Prune oldest backups, counting only timestamp-shaped files we own.
    backups = sorted(
        f for f in bak.glob("*.toml") if re.fullmatch(r"\d{8}-\d{6}(?:-\d+)?", f.stem)
    )
    for old in backups[:-keep]:
        old.unlink()
    return dest


def reload_instance():
    proc = subprocess.run(
        ["noctalia", "msg", "config-reload"],
        capture_output=True,
        text=True,
        timeout=15,
        check=False,
    )
    if proc.returncode == 0:
        print("  reload: noctalia msg config-reload")
    else:
        print("  reload: noctalia not running or reload failed")


def main():
    ap = argparse.ArgumentParser(
        description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter
    )
    ap.add_argument(
        "--apply", action="store_true", help="apply the fold (default: preview only)"
    )
    ap.add_argument(
        "--config-dir", type=Path, default=DEFAULT_CONFIG_DIR, help=argparse.SUPPRESS
    )
    ap.add_argument(
        "--state-dir", type=Path, default=DEFAULT_STATE_DIR, help=argparse.SUPPRESS
    )
    ap.add_argument("--export-file", type=Path, default=None, help=argparse.SUPPRESS)
    args = ap.parse_args()

    config_dir = args.config_dir.resolve()
    state_dir = args.state_dir
    if not config_dir.is_dir():
        sys.exit(f"error: config dir not found: {config_dir}")

    if not args.export_file:
        live = Path(os.path.realpath(Path.home() / ".config" / "noctalia"))
        if live != config_dir:
            print(
                f"warning: ~/.config/noctalia is not linked to {config_dir} (found {live});"
            )
            print("         the live export may describe a different config")

    export = parse_export(args.export_file)

    # Parse per-aspect files; map each top-level root to its owning file.
    files = sorted(config_dir.glob("*.toml"))
    texts = {}
    parsed = {}
    for f in files:
        text = f.read_text()
        texts[f] = text
        parsed[f] = tomli.loads(text)
    root_map = {}
    for f, d in parsed.items():
        for root in d:
            root_map.setdefault(root, f)

    # Collect every change the export implies relative to the repo.
    changes = []
    new_files = {}
    for root, subtree in export.items():
        if not isinstance(subtree, dict):
            continue  # do not fold top-level scalars
        tgt = root_map.get(root)
        if tgt is None:
            new_files[root] = subtree
            continue
        cur = parsed[tgt].get(root)
        collect_changes(cur if isinstance(cur, dict) else {}, subtree, [root], changes)

    sets_by_file, subs_by_file = {}, {}
    for path, old, val in changes:
        f = root_map[path[0]]
        if isinstance(val, dict):  # new subtree
            subs_by_file.setdefault(f, []).append((path, old, val))
        else:
            sets_by_file.setdefault(f, []).append((path, old, val))

    if not changes and not new_files:
        print("No changes to fold. Repo config already matches the export.")
        return

    # Preview
    touched = set(sets_by_file) | set(subs_by_file)
    for f in sorted(touched, key=str):
        rel = os.path.relpath(f, REPO)
        print(f"\n{rel}")
        for path, old, val in sorted(
            sets_by_file.get(f, []), key=lambda c: _dotted(c[0])
        ):
            key = _dotted(path)
            if old is None:
                print(f"  + {key} = {serialize_value(val)}")
            else:
                print(f"  ~ {key}: {serialize_value(old)}  ->  {serialize_value(val)}")
        for path, old, subtree in subs_by_file.get(f, []):
            print(f"  + [{_dotted(path)}]")
            for line in serialize_subtree(path, subtree).splitlines():
                if line.strip():
                    print(f"    {line}")
    for root in new_files:
        print(
            f"\n  + new section root: {root} (new file {root.replace('_', '-')}.toml)"
        )

    if not args.apply:
        total = len(changes) + len(new_files)
        file_count = len(touched) + len(new_files)
        print(
            f"\n{total} change{'s' if total != 1 else ''} in {file_count} file(s)."
        )
        print("Run with --apply to fold into the repo.")
        return

    # Apply
    for f in sorted(touched, key=str):
        data = parsed[f]
        for path, old, val in sets_by_file.get(f, []):
            apply_path(data, path, clean_value(val), as_table=False, old=old)
        for path, old, subtree in subs_by_file.get(f, []):
            apply_path(data, path, clean_value(subtree), as_table=True, old=old)
        f.write_text(restore_comments(texts[f], tomli_w.dumps(data)))

    new_paths = []
    for root, subtree in new_files.items():
        p = config_dir / (root.replace("_", "-") + ".toml")
        p.write_text(tomli_w.dumps(clean_value({root: subtree})))
        new_paths.append(p)
        files.append(p)

    print("  formatting changed files with tombi...")
    run_tombi(sorted(touched, key=str) + new_paths)

    # Completeness: repo-as-loaded must now equal the export (within tolerance).
    repo_after = {}
    for f in files:
        repo_after.update(tomli.loads(f.read_text()))
    diffs = completeness_diffs(export, repo_after)
    if diffs:
        print("error: repo does not fully reproduce the export after applying:")
        for p, old, val in diffs[:20]:
            print(f"  {_dotted(p)}: {serialize_value(old)} != {serialize_value(val)}")
        sys.exit(1)

    if not run_validate(config_dir):
        sys.exit("error: validation failed after applying changes")

    bak = backup_settings(state_dir)
    if bak:
        print(f"  backed up {state_dir}/settings.toml -> {bak}")
        reload_instance()
    else:
        # Should not reach this branch, since a fold implies GUI overrides exist.
        print("warning: settings.toml does not exist. Nothing backuped")

    total = len(changes) + len(new_files)
    print(f"\nDone. {total} change{'s' if total != 1 else ''} folded.")


if __name__ == "__main__":
    main()
