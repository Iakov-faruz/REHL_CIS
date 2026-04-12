#!/usr/bin/env bash
# CIS 6.3.4.1 - Ensure audit log directory mode is configured
# Level: 2
PASS=0; FAIL=0
echo "=== CIS 6.3.4.1 - Audit Log Directory Mode ==="
AUDIT_CONF="/etc/audit/auditd.conf"
[ ! -f "$AUDIT_CONF" ] && { echo "[FAIL] $AUDIT_CONF not found"; exit 1; }
LOG_DIR=$(dirname "$(awk -F= '/^\s*log_file\s*/{print $2}' $AUDIT_CONF | xargs)")
if [ -d "$LOG_DIR" ]; then
    dir_mode=$(stat -Lc '%#a' "$LOG_DIR")
    if [ $(( $dir_mode & 0027 )) -gt 0 ]; then
        echo "[FAIL] $LOG_DIR mode: $dir_mode (should be 0750 or more restrictive)"; ((FAIL++))
    else
        echo "[PASS] $LOG_DIR mode: $dir_mode"; ((PASS++))
    fi
else
    echo "[FAIL] Log directory $LOG_DIR not found"; ((FAIL++))
fi
echo "Results: PASS=$PASS | FAIL=$FAIL"
[ "$FAIL" -eq 0 ] && echo "** PASS **" || echo "** FAIL **"
