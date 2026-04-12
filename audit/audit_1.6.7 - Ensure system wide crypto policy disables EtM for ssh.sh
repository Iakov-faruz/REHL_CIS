#!/usr/bin/env bash
# CIS 1.6.7 - Ensure system wide crypto policy disables EtM for ssh (Manual Audit)

# בדיקה: האם update-crypto-policies קיים במערכת?
if ! command -v update-crypto-policies &> /dev/null; then
    echo " - SKIP: update-crypto-policies command not found (Not a RHEL/Fedora system?)"
    exit 0
fi

CURRENT_POLICY=$(update-crypto-policies --show 2>/dev/null)

if echo "$CURRENT_POLICY" | grep -q "NO-SSHETM"; then
    echo " - PASS: NO-SSHETM subpolicy is applied: $CURRENT_POLICY"
else
    echo " - FAIL: NO-SSHETM subpolicy is NOT applied. Current policy: $CURRENT_POLICY"
    echo " - NOTE: This is a Manual recommendation. Requires RHEL 9.3+ for ETM crypto policy support."
fi
