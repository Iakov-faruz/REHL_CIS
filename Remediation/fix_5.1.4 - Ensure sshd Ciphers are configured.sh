#!/usr/bin/env bash
# CIS 5.1.4 - Ensure sshd Ciphers are configured (Remediation)
# Configure system-wide crypto policy to disable weak ciphers for SSH

echo "=== CIS 5.1.4 - Configuring sshd Ciphers ==="

PMOD_FILE="/etc/crypto-policies/policies/modules/NO-SSHWEAKCIPHERS.pmod"

if [ ! -f "$PMOD_FILE" ]; then
    printf '%s\n' \
      "# This is a subpolicy to disable weak ciphers" \
      "# for the SSH protocol (libssh and OpenSSH)" \
      "cipher@SSH = -3DES-CBC -AES-128-CBC -AES-192-CBC -AES-256-CBC -CHACHA20-POLY1305" \
      > "$PMOD_FILE"
    echo " - Created $PMOD_FILE"
else
    if ! grep -q "cipher@SSH" "$PMOD_FILE"; then
        echo "cipher@SSH = -3DES-CBC -AES-128-CBC -AES-192-CBC -AES-256-CBC -CHACHA20-POLY1305" >> "$PMOD_FILE"
        echo " - Appended cipher@SSH line to $PMOD_FILE"
    else
        echo " - INFO: cipher@SSH already configured in $PMOD_FILE"
    fi
fi

# Get current policy and add subpolicy if not already present
CURRENT_POLICY=$(update-crypto-policies --show 2>/dev/null)
if ! echo "$CURRENT_POLICY" | grep -q "NO-SSHWEAKCIPHERS"; then
    NEW_POLICY="${CURRENT_POLICY}:NO-SSHWEAKCIPHERS"
    update-crypto-policies --set "$NEW_POLICY"
    echo " - Updated crypto policy to: $NEW_POLICY"
else
    echo " - INFO: NO-SSHWEAKCIPHERS already in active policy"
fi

systemctl reload-or-restart sshd 2>/dev/null
echo " - Reloaded sshd"
