#!/usr/bin/env bash
# CIS 6.2.3.8 - Ensure rsyslog logrotate is configured
PASS=0; FAIL=0
echo "=== CIS 6.2.3.8 - Ensure rsyslog logrotate is configured ==="
if [ -f /etc/logrotate.d/syslog ] || grep -R systemd /etc/logrotate.d/ 2>/dev/null; then echo "[PASS] logrotate for syslog found"; ((PASS++))
else echo "[FAIL] logrotate absent for syslog"; ((FAIL++)); fi
echo "Results: PASS=$PASS | FAIL=$FAIL"
[ "$FAIL" -eq 0 ] && echo "** PASS **" || echo "** FAIL **"
