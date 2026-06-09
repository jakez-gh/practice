#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
VENV="$SCRIPT_DIR/.venv"

if [ ! -d "$VENV" ]; then
    echo "Creating virtualenv..."
    python3 -m venv "$VENV"
fi

source "$VENV/bin/activate"

if [ ! -f "$VENV/.deps_installed" ] || [ requirements.txt -nt "$VENV/.deps_installed" ]; then
    echo "Installing dependencies..."
    pip install -q -r "$SCRIPT_DIR/requirements.txt"
    touch "$VENV/.deps_installed"
fi

exec python "$SCRIPT_DIR/anthropic_client.py" "$@"
