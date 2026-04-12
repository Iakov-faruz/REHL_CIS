#!/usr/bin/env bash
# CIS Benchmark: 6.1.2 - Ensure filesystem integrity is regularly checked
# Level: 1 - Server | 1 - Workstation

PASS=0
FAIL=0

echo "============================================="
echo " CIS 6.1.2 - AIDE Scheduled Integrity Check"
echo "============================================="

# Check cron jobs
cron_check=$(grep -Ers '^([^#]+\s+)?(/usr/s?bin/|^\s*)aide(\.wrapper)?\s(--?\S+\s)*(--(check|update)|\$AIDEARGS)\b' /etc/cron.* /etc/crontab /var/spool/cron/ 2>/dev/null)

if [ -n "$cron_check" ]; then
    echo "[PASS] AIDE cron job found:"
    echo "$cron_check"
    ((PASS++))
else
    echo "[INFO] No cron job found. Checking systemd timers..."
    
    svc_enabled=$(systemctl is-enabled aidecheck.service 2>/dev/null)
    timer_enabled=$(systemctl is-enabled aidecheck.timer 2>/dev/null)
    timer_active=$(systemctl is-active aidecheck.timer 2>/dev/null)

    if [[ "$svc_enabled" == "enabled" && "$timer_enabled" == "enabled" && "$timer_active" == "active" ]]; then
        echo "[PASS] aidecheck.service and aidecheck.timer are enabled and active."
        ((PASS++))
    else
        echo "[FAIL] No AIDE schedule found (neither cron nor systemd timer)."
        echo "       aidecheck.service: $svc_enabled"
        echo "       aidecheck.timer:   $timer_enabled (active: $timer_active)"
        ((FAIL++))
    fi
fi

echo ""
echo "Results: PASS=$PASS | FAIL=$FAIL"
[ "$FAIL" -eq 0 ] && echo "- Audit Result: ** PASS **" || echo "- Audit Result: ** FAIL **"
