from pathlib import Path

with open(Path.home() / ".config/kitty-generated.conf", "r") as f:
    print(f.read())
