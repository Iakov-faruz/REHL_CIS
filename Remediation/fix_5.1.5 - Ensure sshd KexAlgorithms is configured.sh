#!/usr/bin/env bash
# CIS 5.1.5 - Ensure sshd KexAlgorithms is configured (Remediation)
# Follow "Ensure system wide crypto policy disables sha1 hash and signature support"

echo "=== CIS 5.1.5 - Configuring sshd KexAlgorithms ==="

PMOD_FILE="/etc/crypto-policies/policies/modules/NO-SHA1.pmod"

if [ ! -f "$PMOD_FILE" ]; then
    printf '%s\n' \
      "# This is a subpolicy dropping the SHA1 hash and signature support" \
      "hash = -SHA1" \
      "sign = -*-SHA1" \
      "sha1_in_certs = 0" \
      > "$PMOD_FILE"
    echo " - Created $PMOD_FILE"
else
    if ! grep -q "hash = -SHA1" "$PMOD_FILE"; then
        printf '%s\n' "hash = -SHA1" "sign = -*-SHA1" "sha1_in_certs = 0" >> "$PMOD_FILE"
        echo " - Appended SHA1 entries to $PMOD_FILE"
    else
        echo " - INFO: SHA1 entries already configured in $PMOD_FILE"
    fi
fi

CURRENT_POLICY=$(update-crypto-policies --show 2>/dev/null)
if ! echo "$CURRENT_POLICY" | grep -q "NO-SHA1"; then
    NEW_POLICY="${CURRENT_POLICY}:NO-SHA1"
    update-crypto-policies --set "$NEW_POLICY"
    echo " - Updated crypto policy to: $NEW_POLICY"
else
    echo " - INFO: NO-SHA1 already in active policy"
fi

systemctl reload-or-restart sshd 2>/dev/null
echo " - Reloaded sshd"
