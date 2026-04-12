#!/usr/bin/env bash
# CIS 5.4.1.5 - Ensure inactive password lock is configured
echo "=== CIS 5.4.1.5 - Ensure inactive password lock is configured ==="
useradd -D -f 45; awk -F: '($2~/^\$.+\$/) {if($7 > 45 || $7 < 0)system ("chage --inactive 45 " $1)}' /etc/shadow
echo "[DONE] Remediation complete"
