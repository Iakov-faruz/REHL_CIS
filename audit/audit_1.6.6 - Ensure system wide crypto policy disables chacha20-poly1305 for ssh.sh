#!/usr/bin/env bash
# CIS 1.6.6 - Ensure system wide crypto policy disables chacha20-poly1305 for ssh (Manual Audit)

CURRENT_POLICY=$(update-crypto-policies --show 2>/dev/null)

if echo "$CURRENT_POLICY" | grep -q "NO-SSHCHACHA20"; then
    echo " - PASS: NO-SSHCHACHA20 subpolicy is applied: $CURRENT_POLICY"
else
    echo " - FAIL: NO-SSHCHACHA20 subpolicy is NOT applied. Current policy: $CURRENT_POLICY"
    echo " - NOTE: This is a Manual recommendation. Verify if CVE-2023-48795 has been addressed."
fi
