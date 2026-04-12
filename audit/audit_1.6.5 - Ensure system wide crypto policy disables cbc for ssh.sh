#!/usr/bin/env bash
# CIS 1.6.5 - Ensure system wide crypto policy disables cbc for ssh (Audit)

CURRENT_POLICY=$(update-crypto-policies --show 2>/dev/null)

if echo "$CURRENT_POLICY" | grep -q "NO-SSHCBC"; then
    echo " - PASS: NO-SSHCBC subpolicy is applied in crypto policy: $CURRENT_POLICY"
else
    echo " - FAIL: NO-SSHCBC subpolicy is NOT applied. Current policy: $CURRENT_POLICY"
fi
