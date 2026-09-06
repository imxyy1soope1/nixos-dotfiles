#!/usr/bin/env bash

set -euo pipefail

root=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)
state="${XDG_STATE_HOME:-$HOME/.local/state}/dotfiles"

ln -sfnT "$root" "$state"
