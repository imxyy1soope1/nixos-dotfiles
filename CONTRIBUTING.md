# Contributing

## Commit message format

This repository uses [Scoped Commits](https://scopedcommits.com/).

```text
<scope>: <description>

[optional body]

[optional trailer]
```

- `<scope>` names the subsystem, area, or module. Write it in lower case.
- `<description>` names the change. Start it with a verb.
- The body gives the reason for the change.
- A trailer gives more information, such as `Co-Authored-By`.

### Subject rules

1. Start the description with a verb. Write `add`, not `added` or `addition`.
2. Keep the subject at 50 characters or less. The maximum is 72 characters.
3. Do not put a period at the end of the subject.
4. Use one action for each commit. If you need the word "and", use two commits.
5. Do not use a semicolon. Split the sentence, or split the commit.
6. Do not use a symbol as a verb. Write `replace A with B`, not `A -> B`.
7. Name the object. Do not write `some changes`, `several fixes`, or
   `misc updates`.
8. Copy names from the source code. Write file names and keys in backticks.
9. Write the description in lower case. Keep the original case of names.

Verb list:

```text
add  drop  remove  replace  move  restore  fix  set  use
enable  disable  migrate  update  pin  unpin  silence  split
```

### Scope rules

Use the most specific scope that covers the whole change. Use one scope when
possible.

Do not use a commit type as the scope. `feat`, `fix`, and `chore` do not name a
subsystem.

A scope can contain `/` or `.`, for example `flake.lock` or `desktop/wm`.

#### Scope suggestions

| Scope | Use for |
|---|---|
| `flake` | `flake.nix` and `flake/` |
| `flake.lock` | `flake.lock` updates only |
| `nix` | Nix settings, channels, and mirrors |
| `niri` | the niri compositor and its bindings |
| `noctalia` | the noctalia shell and its panels |
| `noctalia-greeter` | the login manager |
| `nvim` | Neovim configuration |
| `kitty` | kitty configuration |
| `fish` | fish shell configuration |
| `jj` | Jujutsu configuration and aliases |
| `git` | Git configuration |
| `direnv` | direnv configuration |
| `agents` | AI agent tools and their configuration |
| `server` | the home server |
| `imxyy-nix` | the desktop host |
| `imxyy-nix-x16` | the laptop host |
| `imxyy-nix-wsl` | the WSL host |
| `user` | the user account |
| `persist` | impermanence and persisted paths |
| `secrets` | sops secrets |
| `media` | desktop media applications |
| `build` | Justfile, treefmt, and build tooling |
| `pkgs` | custom packages |
| `lib` | the custom Nix library |
| `modules` | shared modules that have no narrower scope |
| `treewide` | a change that touches many unrelated areas |

#### Two scopes

Use a comma to list two scopes:

```text
nvim, kitty: add kitty-scrollback.nvim integration
```

If no scope fits, use a general scope. If the change has no clear scope, use
`treewide`.

### Body rules

1. Put one empty line between the subject and the body.
2. Explain why the change is necessary.
3. Do not repeat the subject.
4. Write one topic for each paragraph.
5. Wrap each line at 72 columns.
6. Keep conditions and background in the body, not in the subject.

### Trailer rules

Put trailers after one empty line:

```text
noctalia: migrate the storage key back to the keyring

The keyring prevents a plaintext key in the Nix store.

Co-Authored-By: Name <name@example.com>
```

A ticket number can go in the scope or in a trailer:

```text
auth (PROJ-123): fix the login bug
```

```text
auth: fix the login bug

Jira-Ticket: PROJ-123
```

Mark a breaking change in the body:

```text
BREAKING CHANGE: <reason>
```

### Special commits

Reverts and merges can use any format. Use the Git default format when possible:

```text
Revert "noctalia: restore the pre-5.3 launcher appearance"
```

Do not merge a commit with `WIP` in the subject.

### Version updates

The upstream specification shows an arrow for a version change. This project
writes a verb instead:

```text
xwayland: update to 24.1.12
```

### Changelogs

Do not generate a changelog from the commit log. Commit messages serve
developers. Changelogs serve users. Write each changelog entry for its audience.

### Examples

Good subjects:

```text
noctalia: restore the pre-5.3 launcher appearance
niri: force electron applications to use gnome-libsecret
server: drop the stale hardware config
nvim, kitty: add kitty-scrollback.nvim integration
nix: replace nix-racer with selector4nix
flake.lock: update
treewide: drop unused software
```

Bad subjects and their replacements:

| Bad | Good | Reason |
|---|---|---|
| `feat: cine` | `media: add cine` | The subject has no verb. |
| `doas -> sudo` | `user: replace doas with sudo` | A symbol replaces the verb. |
| `chore: update flack.lock` | `flake.lock: update` | `flack` is a spelling error. |
| `noctalia: shell.panel.border = true` | `noctalia: set shell.panel.borders to true` | The key is `borders`. |
| `feat(fish): some changes` | `fish: add the async starship prompt` | `some changes` gives no information. |
| `chore: fix server` | `server: drop the stale hardware config` | The subject names neither the host nor the change. |
| `update flake.lock; sddm -> ly` | two commits | A semicolon joins two actions. |

### Before you commit

1. Run `just fmt`.
2. Run `git diff --cached` or `jj diff`.
3. Read the subject. Check that it answers "what changed".
4. Read the body. Check that it answers "why".
5. Check the spelling of each file name, key, and service name.
6. Check the subject length.
7. Check that the commit has one action.

### Glossary

| Term | Meaning |
|---|---|
| scope | The subsystem, area, or module that the commit touches. |
| subject | The first line of the commit message. |
| trailer | A line at the end of the message that gives more information about the commit. |
| treewide | A change that touches many unrelated areas. |
