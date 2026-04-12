#!/usr/bin/env bash
# CIS 6.3.4.10 - Ensure audit tools group owner is configured
PASS=0; FAIL=0
echo "=== CIS 6.3.4.10 - Audit Tools Group ==="
AUDIT_TOOLS=(/sbin/auditctl /sbin/aureport /sbin/ausearch /sbin/autrace /sbin/auditd /sbin/augenrules)
bad=$(stat -Lc "%n %G" "${AUDIT_TOOLS[@]}" 2>/dev/null | awk '$2 != "root" {print}')
if [ -z "$bad" ]; then
    echo "[PASS] All audit tools group owned by root"; ((PASS++))
else
    echo "[FAIL] Tools not group owned by root: $bad"; ((FAIL++))
fi
echo "Results: PASS=$PASS | FAIL=$FAIL"
[ "$FAIL" -eq 0 ] && echo "** PASS **" || echo "** FAIL **"
