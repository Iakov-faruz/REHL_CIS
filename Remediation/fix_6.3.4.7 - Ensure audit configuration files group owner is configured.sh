#!/usr/bin/env bash
# CIS 6.3.4.7 - Ensure audit configuration files group owner is configured
echo "=== CIS 6.3.4.7 - Fix Audit Config Files Group ==="
find /etc/audit/ -type f \( -name '*.conf' -o -name '*.rules' \) ! -group root -exec chgrp root {} +
echo "[DONE] All audit config files group owned by root"
