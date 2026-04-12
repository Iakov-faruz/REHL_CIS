#!/usr/bin/env bash
# CIS 7.2.2 - Ensure password fields are not empty
echo "=== CIS 7.2.2 - Lock Empty-Password Accounts ==="
for user in $(awk -F: '($2 == "") {print $1}' /etc/shadow); do
    echo "[FIX] Locking account: $user"
    passwd -l "$user"
done
echo "[DONE] Empty-password accounts locked"
