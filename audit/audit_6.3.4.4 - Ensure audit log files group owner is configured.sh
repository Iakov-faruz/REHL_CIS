#!/usr/bin/env bash
# CIS 6.3.4.4 - Ensure audit log files group owner is configured
PASS=0; FAIL=0
echo "=== CIS 6.3.4.4 - Audit Log Files Group ==="
AUDIT_CONF="/etc/audit/auditd.conf"
[ ! -f "$AUDIT_CONF" ] && { echo "[FAIL] $AUDIT_CONF not found"; exit 1; }
LOG_DIR=$(dirname "$(awk -F= '/^\s*log_file\s*/{print $2}' $AUDIT_CONF | xargs)")
log_group=$(awk -F= '/^\s*log_group\s*/{print $2}' $AUDIT_CONF | xargs)
if echo "$log_group" | grep -Pq '^(root|adm)$'; then
    echo "[PASS] log_group is: $log_group"; ((PASS++))
else
    echo "[FAIL] log_group is: $log_group (should be root or adm)"; ((FAIL++))
fi
bad=$(find "$LOG_DIR" -maxdepth 1 -type f \( ! -group root -a ! -group adm \) 2>/dev/null)
if [ -z "$bad" ]; then
    echo "[PASS] All audit log files group owned by root or adm"; ((PASS++))
else
    echo "[FAIL] Files with wrong group:"; echo "$bad"; ((FAIL++))
fi
echo "Results: PASS=$PASS | FAIL=$FAIL"
[ "$FAIL" -eq 0 ] && echo "** PASS **" || echo "** FAIL **"
