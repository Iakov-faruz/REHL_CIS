#!/usr/bin/env bash
# CIS 7.1.9 - Ensure permissions on /etc/shells are configured
echo "=== CIS 7.1.9 - Fix /etc/shells ==="
[ -e "/etc/shells" ] || { echo "[INFO] /etc/shells does not exist"; exit 0; }
chmod u-x,go-wx "/etc/shells"
chown root:root "/etc/shells"
echo "[DONE] /etc/shells permissions fixed"
