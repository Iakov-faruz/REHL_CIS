#!/usr/bin/env bash
# CIS Benchmark: 6.2.1.1 - Ensure journald service is enabled and active
# Level: 1 - Server | 1 - Workstation

PASS=0
FAIL=0

echo "====================================================="
echo " CIS 6.2.1.1 - journald Service Enabled and Active"
echo "====================================================="

# Check enabled status (expected: static)
enabled_status=$(systemctl is-enabled systemd-journald.service 2>/dev/null)
if [[ "$enabled_status" == "static" ]]; then
    echo "[PASS] systemd-journald.service is 'static' (correct - no [Install] section by design)"
    ((PASS++))
else
    echo "[FAIL] systemd-journald.service status: $enabled_status (expected: static)"
    ((FAIL++))
fi

# Check active status
active_status=$(systemctl is-active systemd-journald.service 2>/dev/null)
if [[ "$active_status" == "active" ]]; then
    echo "[PASS] systemd-journald.service is active"
    ((PASS++))
else
    echo "[FAIL] systemd-journald.service is NOT active (status: $active_status)"
    ((FAIL++))
fi

echo ""
echo "Results: PASS=$PASS | FAIL=$FAIL"
[ "$FAIL" -eq 0 ] && echo "- Audit Result: ** PASS **" || echo "- Audit Result: ** FAIL **"
