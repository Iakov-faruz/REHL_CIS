#!/usr/bin/env bash
# CIS 7.1.5 - Ensure permissions on /etc/shadow are configured
echo "=== CIS 7.1.5 - Fix /etc/shadow ==="
[ -e "/etc/shadow" ] || { echo "[INFO] /etc/shadow does not exist"; exit 0; }
chmod 0000 "/etc/shadow"
chown root:root "/etc/shadow"
echo "[DONE] /etc/shadow permissions fixed"
