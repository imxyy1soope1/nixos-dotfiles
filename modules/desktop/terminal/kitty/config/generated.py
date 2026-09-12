import subprocess
from pathlib import Path

with open(Path.home() / ".config/kitty-generated.conf", "r") as f:
    print(f.read())

with open(Path.home() / ".config/kitty-generated.conf", "r") as f:
    print(f.read())

try:
    # NOTE: in headless mode `:KittyScrollbackGenerateKittens` uses vim.print,
    # which writes to stderr.
    proc = subprocess.run(
        ["nvim", "--headless", "+KittyScrollbackGenerateKittens"],
        check=True,
        stdout=subprocess.PIPE,
        stderr=subprocess.STDOUT,
        text=True,
    )
    print(proc.stdout)
except subprocess.SubprocessError:
    pass
