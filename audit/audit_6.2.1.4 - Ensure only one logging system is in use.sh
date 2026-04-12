#!/usr/bin/env bash
# CIS Benchmark: 6.2.1.4 - Ensure only one logging system is in use
# Level: 1 - Server | 1 - Workstation

PASS=0
FAIL=0

echo "====================================================="
echo " CIS 6.2.1.4 - Only One Logging System In Use"
echo "====================================================="

rsyslog_active=false
journald_active=false

systemctl is-active --quiet rsyslog && rsyslog_active=true
systemctl is-active --quiet systemd-journald && journald_active=true

if $rsyslog_active && $journald_active; then
    echo "[REVIEW] BOTH rsyslog and journald are active."
    echo "         Configure only ONE logging system per site policy."
    ((FAIL++))
elif $rsyslog_active; then
    echo "[PASS] rsyslog is in use. Follow rsyslog recommendations (6.2.3)."
    ((PASS++))
elif $journald_active; then
    echo "[PASS] journald is in use. Follow journald recommendations (6.2.2)."
    ((PASS++))
else
    echo "[FAIL] Unable to determine logging system. Neither rsyslog nor journald is active."
    ((FAIL++))
fi

echo ""
echo "Results: PASS=$PASS | FAIL=$FAIL"
[ "$FAIL" -eq 0 ] && echo "- Audit Result: ** PASS **" || echo "- Audit Result: ** FAIL **"
