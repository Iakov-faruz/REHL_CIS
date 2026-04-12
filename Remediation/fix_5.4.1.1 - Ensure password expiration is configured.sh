#!/usr/bin/env bash
# CIS 5.4.1.1 - Ensure password expiration is configured
echo "=== CIS 5.4.1.1 - Ensure password expiration is configured ==="
if grep -q '^PASS_MAX_DAYS' /etc/login.defs; then sed -ri 's/^PASS_MAX_DAYS.*/PASS_MAX_DAYS 365/' /etc/login.defs; else echo "PASS_MAX_DAYS 365" >> /etc/login.defs; fi; awk -F: '($2~/^\$.+\$/) {if($5 > 365 || $5 < 1)system ("chage --maxdays 365 " $1)}' /etc/shadow
echo "[DONE] Remediation complete"
