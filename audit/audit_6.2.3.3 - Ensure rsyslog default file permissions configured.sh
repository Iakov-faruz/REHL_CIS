#!/usr/bin/env bash
# CIS 6.2.3.3 - Ensure rsyslog default file permissions configured
PASS=0; FAIL=0
echo "=== CIS 6.2.3.3 - rsyslog file permissions ==="
if grep -Pqs '^\s*\$FileCreateMode\s+0640\b' /etc/rsyslog.conf /etc/rsyslog.d/*.conf; then
    echo "[PASS] \$FileCreateMode 0640 is configured"; ((PASS++))
else
    echo "[FAIL] \$FileCreateMode 0640 not found"; ((FAIL++))
fi
echo "Results: PASS=$PASS | FAIL=$FAIL"
[ "$FAIL" -eq 0 ] && echo "** PASS **" || echo "** FAIL **"
