#!/usr/bin/env bash
# CIS 6.3.4.9 - Ensure audit tools owner is configured
PASS=0; FAIL=0
echo "=== CIS 6.3.4.9 - Audit Tools Owner ==="
AUDIT_TOOLS=(/sbin/auditctl /sbin/aureport /sbin/ausearch /sbin/autrace /sbin/auditd /sbin/augenrules)
bad=$(stat -Lc "%n %U" "${AUDIT_TOOLS[@]}" 2>/dev/null | awk '$2 != "root" {print}')
if [ -z "$bad" ]; then
    echo "[PASS] All audit tools owned by root"; ((PASS++))
else
    echo "[FAIL] Tools not owned by root: $bad"; ((FAIL++))
fi
echo "Results: PASS=$PASS | FAIL=$FAIL"
[ "$FAIL" -eq 0 ] && echo "** PASS **" || echo "** FAIL **"
