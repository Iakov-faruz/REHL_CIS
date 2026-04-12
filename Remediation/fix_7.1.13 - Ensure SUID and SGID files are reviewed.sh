#!/usr/bin/env bash
# CIS 7.1.13 - Ensure SUID and SGID files are reviewed
echo "=== CIS 7.1.13 - SUID/SGID Review ==="
echo "[INFO] This is a manual review item."
echo "SUID/SGID files on this system:"
find / -xdev -type f \( -perm -4000 -o -perm -2000 \) -exec ls -la {} \; 2>/dev/null
echo "[NOTE] Remove SUID/SGID from unauthorized programs with: chmod u-s or chmod g-s"
