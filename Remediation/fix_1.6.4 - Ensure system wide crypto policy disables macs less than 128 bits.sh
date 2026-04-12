#!/usr/bin/env bash
# CIS 1.6.4 - Ensure system wide crypto policy disables macs less than 128 bits
# Remediation script for RHEL 9 / CIS Benchmark

PMOD_DIR="/etc/crypto-policies/policies/modules"
PMOD_FILE="$PMOD_DIR/NO-WEAKMAC.pmod"

# Get current policy
CURRENT_POLICY=$(update-crypto-policies --show 2>/dev/null | awk '{print $1}')

# Check if NO-WEAKMAC subpolicy already applied
if echo "$CURRENT_POLICY" | grep -q "NO-WEAKMAC"; then
    echo " - NO-WEAKMAC subpolicy is already applied in the crypto policy: $CURRENT_POLICY"
else
    echo " - NO-WEAKMAC subpolicy is not applied - configuring..."

    # Create pmod directory if it doesn't exist
    if [ ! -d "$PMOD_DIR" ]; then
        echo " - Creating directory $PMOD_DIR"
        mkdir -p "$PMOD_DIR"
    fi

    # Create NO-WEAKMAC.pmod file if it doesn't exist
    if [ ! -f "$PMOD_FILE" ]; then
        echo " - Creating $PMOD_FILE"
        printf '%s\n' \
            "# This is a subpolicy to disable weak macs (less than 128 bits)" \
            "mac = -*-64" > "$PMOD_FILE"
        echo " - Created $PMOD_FILE"
    else
        echo " - $PMOD_FILE already exists"
    fi

    # Build new policy string preserving existing subpolicies
    NEW_POLICY="${CURRENT_POLICY}:NO-WEAKMAC"
    echo " - Updating crypto policy to: $NEW_POLICY"
    update-crypto-policies --set "$NEW_POLICY"
    echo " - Current policy: $(update-crypto-policies --show)"
    echo ""
    echo " - NOTE: A system reboot is recommended to apply changes to all running services."
fi

echo " - Done. Weak MAC disable remediation complete."
