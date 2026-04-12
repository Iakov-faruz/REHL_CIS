#!/usr/bin/env bash
# CIS 5.4.1.3 - Ensure password expiration warning days is configured
echo "=== CIS 5.4.1.3 - Ensure password expiration warning days is configured ==="
if grep -q '^PASS_WARN_AGE' /etc/login.defs; then sed -ri 's/^PASS_WARN_AGE.*/PASS_WARN_AGE 7/' /etc/login.defs; else echo "PASS_WARN_AGE 7" >> /etc/login.defs; fi; awk -F: '($2~/^\$.+\$/) {if($6 < 7)system ("chage --warndays 7 " $1)}' /etc/shadow
echo "[DONE] Remediation complete"
