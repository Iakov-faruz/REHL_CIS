#!/usr/bin/env bash
# CIS 7.1.13 - Ensure SUID and SGID files are reviewed
echo "=== CIS 7.1.13 - SUID/SGID Files Review ==="
suid_count=$(find / -xdev -type f \( -perm -4000 -o -perm -2000 \) 2>/dev/null | wc -l)
echo "[INFO] Found $suid_count SUID/SGID files. Review manually:"
find / -xdev -type f \( -perm -4000 -o -perm -2000 \) 2>/dev/null
echo "[NOTE] Manual review required - verify each program is legitimate"
