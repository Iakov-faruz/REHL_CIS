#!/usr/bin/env bash
# CIS 1.6.3 - Ensure system wide crypto policy disables sha1 hash and signature support (Audit)

CURRENT_POLICY=$(update-crypto-policies --show 2>/dev/null)

# Check if NO-SHA1 subpolicy is applied
if echo "$CURRENT_POLICY" | grep -q "NO-SHA1"; then
    echo " - PASS: NO-SHA1 subpolicy is applied in crypto policy: $CURRENT_POLICY"
else
    echo " - FAIL: NO-SHA1 subpolicy is NOT applied. Current policy: $CURRENT_POLICY"
fi

# Check if sha1_in_certs and sign/hash restrictions are in place
if grep -Pqs '^\h*hash\h*=\h*.*-SHA1\b' /etc/crypto-policies/policies/modules/NO-SHA1.pmod 2>/dev/null; then
    echo " - PASS: NO-SHA1.pmod contains hash = -SHA1 restriction"
else
    echo " - INFO: NO-SHA1.pmod may not exist or may not contain hash = -SHA1"
fi
