#!/usr/bin/env bash
# CIS 6.3.4.5 - Ensure audit configuration files mode is configured
echo "=== CIS 6.3.4.5 - Fix Audit Config Files Mode ==="
find /etc/audit/ -type f \( -name '*.conf' -o -name '*.rules' \) -exec chmod u-x,g-wx,o-rwx {} +
echo "[DONE] Audit config files set to mode 0640 or more restrictive"
