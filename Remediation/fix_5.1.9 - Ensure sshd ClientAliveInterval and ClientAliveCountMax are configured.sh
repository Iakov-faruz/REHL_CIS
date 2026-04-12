#!/usr/bin/env bash
# CIS 5.1.9 - Ensure sshd ClientAliveInterval and ClientAliveCountMax are configured (Remediation)

echo "=== CIS 5.1.9 - Configuring ClientAliveInterval and ClientAliveCountMax ==="

SSHD_CONFIG="/etc/ssh/sshd_config"

# Helper function to set sshd_config parameter above Include/Match
set_sshd_param() {
    local PARAM="$1"
    local VALUE="$2"
    if grep -Piq "^\h*$PARAM\h" "$SSHD_CONFIG" 2>/dev/null; then
        sed -ri "s/^\h*($PARAM\h+).*/$PARAM $VALUE/" "$SSHD_CONFIG"
    else
        sed -i "/^\h*Include\h\|^\h*Match\h/i $PARAM $VALUE" "$SSHD_CONFIG" 2>/dev/null
        if ! grep -q "^$PARAM" "$SSHD_CONFIG"; then
            echo "$PARAM $VALUE" >> "$SSHD_CONFIG"
        fi
    fi
    echo " - Set $PARAM $VALUE"
}

set_sshd_param "ClientAliveInterval" "15"
set_sshd_param "ClientAliveCountMax" "3"

systemctl reload sshd 2>/dev/null
echo " - Reloaded sshd"
