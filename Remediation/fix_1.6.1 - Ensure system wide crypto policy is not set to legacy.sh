#!/usr/bin/env bash
# CIS 1.6.1 - Ensure system wide crypto policy is not set to legacy
# Remediation script for RHEL 9 / CIS Benchmark

# Check current policy
CURRENT_POLICY=$(update-crypto-policies --show 2>/dev/null)

if echo "$CURRENT_POLICY" | grep -Pi '^\s*LEGACY\b'; then
    echo " - System-wide crypto policy is set to LEGACY - remediating..."
    echo " - Setting crypto policy to DEFAULT"
    update-crypto-policies --set DEFAULT
    update-crypto-policies
    echo " - Crypto policy updated. Current policy: $(update-crypto-policies --show)"
else
    echo " - System-wide crypto policy is NOT set to LEGACY - no changes needed"
    echo " - Current policy: $CURRENT_POLICY"
fi

echo ""
echo " - Note: If FIPS is required by local site policy, run: fips-mode-setup --enable"
echo " - Done. Crypto policy (not LEGACY) remediation complete."
