#!/usr/bin/env bash
# CIS 7.1.1 - Ensure permissions on /etc/passwd are configured
echo "=== CIS 7.1.1 - Fix /etc/passwd ==="
[ -e "/etc/passwd" ] || { echo "[INFO] /etc/passwd does not exist"; exit 0; }
chmod u-x,go-wx "/etc/passwd"
chown root:root "/etc/passwd"
echo "[DONE] /etc/passwd permissions fixed"
