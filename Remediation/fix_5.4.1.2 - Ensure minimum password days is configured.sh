#!/usr/bin/env bash
# CIS 5.4.1.2 - Ensure minimum password days is configured
echo "=== CIS 5.4.1.2 - Ensure minimum password days is configured ==="
if grep -q '^PASS_MIN_DAYS' /etc/login.defs; then sed -ri 's/^PASS_MIN_DAYS.*/PASS_MIN_DAYS 1/' /etc/login.defs; else echo "PASS_MIN_DAYS 1" >> /etc/login.defs; fi; awk -F: '($2~/^\$.+\$/) {if($4 < 1)system ("chage --mindays 1 " $1)}' /etc/shadow
echo "[DONE] Remediation complete"
