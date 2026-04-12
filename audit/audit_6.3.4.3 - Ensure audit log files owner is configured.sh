#!/usr/bin/env bash
# CIS 6.3.4.3 - Ensure audit log files owner is configured
PASS=0; FAIL=0
echo "=== CIS 6.3.4.3 - Audit Log Files Owner ==="
AUDIT_CONF="/etc/audit/auditd.conf"
[ ! -f "$AUDIT_CONF" ] && { echo "[FAIL] $AUDIT_CONF not found"; exit 1; }
LOG_DIR=$(dirname "$(awk -F= '/^\s*log_file\s*/{print $2}' $AUDIT_CONF | xargs)")
bad=$(find "$LOG_DIR" -maxdepth 1 -type f ! -user root 2>/dev/null)
if [ -z "$bad" ]; then
    echo "[PASS] All audit log files owned by root"; ((PASS++))
else
    echo "[FAIL] Files not owned by root:"; echo "$bad"; ((FAIL++))
fi
echo "Results: PASS=$PASS | FAIL=$FAIL"
[ "$FAIL" -eq 0 ] && echo "** PASS **" || echo "** FAIL **"
