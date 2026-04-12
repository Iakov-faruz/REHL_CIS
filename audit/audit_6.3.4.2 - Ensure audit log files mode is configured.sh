#!/usr/bin/env bash
# CIS 6.3.4.2 - Ensure audit log files mode is configured
PASS=0; FAIL=0
echo "=== CIS 6.3.4.2 - Audit Log Files Mode ==="
AUDIT_CONF="/etc/audit/auditd.conf"
[ ! -f "$AUDIT_CONF" ] && { echo "[FAIL] $AUDIT_CONF not found"; exit 1; }
LOG_DIR=$(dirname "$(awk -F= '/^\s*log_file\s*/{print $2}' $AUDIT_CONF | xargs)")
bad_files=$(find "$LOG_DIR" -maxdepth 1 -type f -perm /0137 2>/dev/null)
if [ -z "$bad_files" ]; then
    echo "[PASS] All audit log files are mode 0640 or more restrictive"; ((PASS++))
else
    echo "[FAIL] Files with excess permissions:"; echo "$bad_files"; ((FAIL++))
fi
echo "Results: PASS=$PASS | FAIL=$FAIL"
[ "$FAIL" -eq 0 ] && echo "** PASS **" || echo "** FAIL **"
