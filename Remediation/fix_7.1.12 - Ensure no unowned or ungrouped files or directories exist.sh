#!/usr/bin/env bash
# CIS 7.1.12 - Ensure no unowned or ungrouped files or directories exist
echo "=== CIS 7.1.12 - Fix Unowned Files ==="
echo "[INFO] Listing unowned files for manual review:"
find / -xdev \( -type f -o -type d \) \( -nouser -o -nogroup \) ! -path "/proc/*" ! -path "/sys/*" 2>/dev/null
echo "[NOTE] Assign proper ownership manually based on the list above"
