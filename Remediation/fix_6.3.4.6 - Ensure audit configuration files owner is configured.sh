#!/usr/bin/env bash
# CIS 6.3.4.6 - Ensure audit configuration files owner is configured
echo "=== CIS 6.3.4.6 - Fix Audit Config Files Owner ==="
find /etc/audit/ -type f \( -name '*.conf' -o -name '*.rules' \) ! -user root -exec chown root {} +
echo "[DONE] All audit config files owned by root"
