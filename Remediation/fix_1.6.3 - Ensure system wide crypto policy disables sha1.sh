#!/usr/bin/env bash
# CIS 1.6.3 - Ensure system wide crypto policy disables sha1 hash and signature support
# Remediation script for RHEL 9 / CIS Benchmark

PMOD_DIR="/etc/crypto-policies/policies/modules"
PMOD_FILE="$PMOD_DIR/NO-SHA1.pmod"

# Get current policy
CURRENT_POLICY=$(update-crypto-policies --show 2>/dev/null | awk '{print $1}')
BASE_POLICY=$(echo "$CURRENT_POLICY" | cut -d: -f1)

# Check if NO-SHA1 subpolicy already applied
if echo "$CURRENT_POLICY" | grep -q "NO-SHA1"; then
    echo " - NO-SHA1 subpolicy is already applied in the crypto policy: $CURRENT_POLICY"
else
    echo " - NO-SHA1 subpolicy is not applied - configuring..."

    # Create pmod directory if it doesn't exist
    if [ ! -d "$PMOD_DIR" ]; then
        echo " - Creating directory $PMOD_DIR"
        mkdir -p "$PMOD_DIR"
    fi

    # Create NO-SHA1.pmod file if it doesn't exist
    if [ ! -f "$PMOD_FILE" ]; then
        echo " - Creating $PMOD_FILE"
        printf '%s\n' \
            "# This is a subpolicy dropping the SHA1 hash and signature support" \
            "hash = -SHA1" \
            "sign = -*-SHA1" \
            "sha1_in_certs = 0" > "$PMOD_FILE"
        echo " - Created $PMOD_FILE"
    else
        echo " - $PMOD_FILE already exists"
    fi

    # Build new policy string preserving existing subpolicies
    NEW_POLICY="${CURRENT_POLICY}:NO-SHA1"
    echo " - Updating crypto policy to: $NEW_POLICY"
    update-crypto-policies --set "$NEW_POLICY"
    echo " - Current policy: $(update-crypto-policies --show)"
    echo ""
    echo " - NOTE: A system reboot is recommended to apply changes to all running services."
fi

echo " - Done. SHA1 disable remediation complete."
