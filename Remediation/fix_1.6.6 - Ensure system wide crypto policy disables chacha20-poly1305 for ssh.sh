#!/usr/bin/env bash
# CIS 1.6.6 - Ensure system wide crypto policy disables chacha20-poly1305 for ssh (Manual)
# Remediation script for RHEL 9 / CIS Benchmark
# Note: This recommendation may be skipped if CVE-2023-48795 has been addressed
# and it meets local site policy.

PMOD_DIR="/etc/crypto-policies/policies/modules"
PMOD_FILE="$PMOD_DIR/NO-SSHCHACHA20.pmod"

# Get current policy
CURRENT_POLICY=$(update-crypto-policies --show 2>/dev/null | awk '{print $1}')

# Check if NO-SSHCHACHA20 subpolicy already applied
if echo "$CURRENT_POLICY" | grep -q "NO-SSHCHACHA20"; then
    echo " - NO-SSHCHACHA20 subpolicy is already applied: $CURRENT_POLICY"
else
    echo " - NO-SSHCHACHA20 subpolicy is not applied - configuring..."

    # Create pmod directory if it doesn't exist
    if [ ! -d "$PMOD_DIR" ]; then
        echo " - Creating directory $PMOD_DIR"
        mkdir -p "$PMOD_DIR"
    fi

    # Create NO-SSHCHACHA20.pmod file if it doesn't exist
    if [ ! -f "$PMOD_FILE" ]; then
        echo " - Creating $PMOD_FILE"
        printf '%s\n' \
            "# This is a subpolicy to disable the chacha20-poly1305 ciphers" \
            "# for the SSH protocol (libssh and OpenSSH)" \
            "cipher@SSH = -CHACHA20-POLY1305" > "$PMOD_FILE"
        echo " - Created $PMOD_FILE"
    else
        echo " - $PMOD_FILE already exists"
    fi

    # Build new policy string preserving existing subpolicies
    NEW_POLICY="${CURRENT_POLICY}:NO-SSHCHACHA20"
    echo " - Updating crypto policy to: $NEW_POLICY"
    update-crypto-policies --set "$NEW_POLICY"
    echo " - Current policy: $(update-crypto-policies --show)"
    echo ""
    echo " - NOTE: A system reboot is recommended to apply changes to all running services."
fi

echo " - Done. SSH chacha20-poly1305 disable remediation complete."
