#!/usr/bin/env bash
# CIS 5.1.6 - Ensure sshd MACs are configured (Remediation)
# Configure system-wide crypto policy to disable weak MACs for SSH

echo "=== CIS 5.1.6 - Configuring sshd MACs ==="

PMOD_FILE="/etc/crypto-policies/policies/modules/NO-SSHWEAKMACS.pmod"

if [ ! -f "$PMOD_FILE" ]; then
    printf '%s\n' \
      "# This is a subpolicy to disable weak MACs" \
      "# for the SSH protocol (libssh and OpenSSH)" \
      "mac@SSH = -HMAC-MD5* -UMAC-64* -UMAC-128*" \
      > "$PMOD_FILE"
    echo " - Created $PMOD_FILE"
else
    if ! grep -q "mac@SSH" "$PMOD_FILE"; then
        echo "mac@SSH = -HMAC-MD5* -UMAC-64* -UMAC-128*" >> "$PMOD_FILE"
        echo " - Appended mac@SSH line to $PMOD_FILE"
    else
        echo " - INFO: mac@SSH already configured in $PMOD_FILE"
    fi
fi

CURRENT_POLICY=$(update-crypto-policies --show 2>/dev/null)
if ! echo "$CURRENT_POLICY" | grep -q "NO-SSHWEAKMACS"; then
    NEW_POLICY="${CURRENT_POLICY}:NO-SSHWEAKMACS"
    update-crypto-policies --set "$NEW_POLICY"
    echo " - Updated crypto policy to: $NEW_POLICY"
else
    echo " - INFO: NO-SSHWEAKMACS already in active policy"
fi

systemctl reload-or-restart sshd 2>/dev/null
echo " - Reloaded sshd"
