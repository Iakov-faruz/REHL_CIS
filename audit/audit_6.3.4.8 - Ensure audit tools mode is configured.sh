#!/usr/bin/env bash
# CIS 6.3.4.8 - Ensure audit tools mode is configured
PASS=0; FAIL=0
echo "=== CIS 6.3.4.8 - Audit Tools Mode ==="
AUDIT_TOOLS=(/sbin/auditctl /sbin/aureport /sbin/ausearch /sbin/autrace /sbin/auditd /sbin/augenrules)
for tool in "${AUDIT_TOOLS[@]}"; do
    [ ! -f "$tool" ] && continue
    t_mode=$(stat -Lc '%#a' "$tool")
    if [ $(( $t_mode & 0022 )) -gt 0 ]; then
        echo "[FAIL] $tool mode: $t_mode (should be 0755 or more restrictive)"; ((FAIL++))
    else
        echo "[PASS] $tool mode: $t_mode"; ((PASS++))
    fi
done
echo "Results: PASS=$PASS | FAIL=$FAIL"
[ "$FAIL" -eq 0 ] && echo "** PASS **" || echo "** FAIL **"
