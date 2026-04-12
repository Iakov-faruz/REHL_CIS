#!/usr/bin/env bash
# CIS 7.1.4 - Ensure permissions on /etc/group- are configured
echo "=== CIS 7.1.4 - Fix /etc/group- ==="
[ -e "/etc/group-" ] || { echo "[INFO] /etc/group- does not exist"; exit 0; }
chmod u-x,go-wx "/etc/group-"
chown root:root "/etc/group-"
echo "[DONE] /etc/group- permissions fixed"
