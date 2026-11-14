#!/usr/bin/env bash

set -euo pipefail

echo "================================"
echo "     KRYPTA OS - Environment"
echo "================================"
echo

check_command() {
    local tool="$1"

    if command -v "$tool" > /dev/null 2>&1; then
        printf "[OK]      %s\n" "$tool"
    else
        printf "[MISSING] %s\n" "$tool"
        return 1
    fi
}

missing=0

for tool in git make gcc python3 curl wget; do
    check_command "$tool" || missing=1
done

echo
echo "Host architecture: $(uname -m)"
echo "Kernel version:    $(uname -r)"
echo

if [[ "$missing" -eq 0 ]]; then
    echo "[SUCCESS] Base development environment is ready."
else
    echo "[WARNING] Some required tools are missing."
    exit 1
fi