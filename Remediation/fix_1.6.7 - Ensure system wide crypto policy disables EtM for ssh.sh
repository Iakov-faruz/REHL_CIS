#!/usr/bin/env bash
# CIS 1.6.7 - Ensure system wide crypto policy disables EtM for ssh (Manual)
# Remediation script for RHEL 9 / CIS Benchmark
# Note: This recommendation may be skipped if CVE-2023-48795 has been addressed
# or if CBC is disabled for OpenSSH server.

PMOD_DIR="/etc/crypto-policies/policies/modules"
PMOD_FILE="$PMOD_DIR/NO-SSHETM.pmod"

# Get current policy
CURRENT_POLICY=$(update-crypto-policies --show 2>/dev/null | awk '{print $1}')

# Check if NO-SSHETM subpolicy already applied
if echo "$CURRENT_POLICY" | grep -q "NO-SSHETM"; then
    echo " - NO-SSHETM subpolicy is already applied: $CURRENT_POLICY"
else
    echo " - NO-SSHETM subpolicy is not applied - configuring..."

    # Create pmod directory if it doesn't exist
    if [ ! -d "$PMOD_DIR" ]; then
        echo " - Creating directory $PMOD_DIR"
        mkdir -p "$PMOD_DIR"
    fi

    # Create NO-SSHETM.pmod file if it doesn't exist
    if [ ! -f "$PMOD_FILE" ]; then
        echo " - Creating $PMOD_FILE"
        printf '%s\n' \
            "# This is a subpolicy to disable Encrypt then MAC" \
            "# for the SSH protocol (libssh and OpenSSH)" \
            "etm@SSH = DISABLE_ETM" > "$PMOD_FILE"
        echo " - Created $PMOD_FILE"
    else
        echo " - $PMOD_FILE already exists"
    fi

    # Build new policy string preserving existing subpolicies
    NEW_POLICY="${CURRENT_POLICY}:NO-SSHETM"
    echo " - Updating crypto policy to: $NEW_POLICY"
    update-crypto-policies --set "$NEW_POLICY"
    echo " - Current policy: $(update-crypto-policies --show)"
    echo ""
    echo " - NOTE: A system reboot is recommended to apply changes to all running services."
    echo " - NOTE: The ability to disable EtM through system wide crypto policy was added in RHEL 9.3"
fi

echo " - Done. SSH EtM disable remediation complete."
