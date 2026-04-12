#!/usr/bin/env bash
# CIS 1.6.1 - Ensure system wide crypto policy is not set to legacy (Audit)

CURRENT_POLICY=$(update-crypto-policies --show 2>/dev/null)

if echo "$CURRENT_POLICY" | grep -Pi '^\s*LEGACY\b'; then
    echo " - FAIL: System-wide crypto policy is set to LEGACY: $CURRENT_POLICY"
else
    echo " - PASS: System-wide crypto policy is NOT set to LEGACY: $CURRENT_POLICY"
fi
