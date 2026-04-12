#!/usr/bin/env bash
# CIS Benchmark: 7.2.x - Fix Local User and Group Settings
# Level: 1

echo "=============================================="
echo " CIS 7.2.x - Fix Local User and Group Settings"
echo "=============================================="

# 7.2.1 - Convert to shadowed passwords
echo "[INFO] 7.2.1: Converting to shadowed passwords..."
pwconv
grpconv

# 7.2.2 - Lock accounts with empty passwords
echo "[INFO] 7.2.2: Locking accounts with empty passwords..."
empty_users=$(awk -F: '($2 == "") {print $1}' /etc/shadow)
if [ -n "$empty_users" ]; then
    for user in $empty_users; do
        echo "[FIX] Locking account: $user"
        passwd -l "$user"
    done
else
    echo "[INFO] No accounts with empty passwords found."
fi

echo "[DONE] User/group settings remediation complete."
echo "[NOTE] 7.2.3: If groups are missing from /etc/group, manually add them with groupadd."
