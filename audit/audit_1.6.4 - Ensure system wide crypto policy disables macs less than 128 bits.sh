#!/usr/bin/env bash
# CIS 1.6.4 - Ensure system wide crypto policy disables macs less than 128 bits (Audit)

CURRENT_POLICY=$(update-crypto-policies --show 2>/dev/null)

if echo "$CURRENT_POLICY" | grep -q "NO-WEAKMAC"; then
    echo " - PASS: NO-WEAKMAC subpolicy is applied in crypto policy: $CURRENT_POLICY"
else
    echo " - FAIL: NO-WEAKMAC subpolicy is NOT applied. Current policy: $CURRENT_POLICY"
fi
