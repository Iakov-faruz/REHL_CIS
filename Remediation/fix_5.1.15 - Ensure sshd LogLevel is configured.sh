#!/usr/bin/env bash
# CIS 5.1.15 - Ensure sshd LogLevel is configured (Remediation)
SSHD_CONFIG="/etc/ssh/sshd_config"
echo "=== CIS 5.1.15 - Setting LogLevel ==="
if grep -Piq '^\h*LogLevel\h' "$SSHD_CONFIG"; then
    sed -ri 's/^\h*(LogLevel\h+).*/LogLevel VERBOSE/' "$SSHD_CONFIG"
else
    sed -i '/^\h*Include\h\|^\h*Match\h/i LogLevel VERBOSE' "$SSHD_CONFIG" 2>/dev/null
    grep -q "^LogLevel" "$SSHD_CONFIG" || echo "LogLevel VERBOSE" >> "$SSHD_CONFIG"
fi
echo " - Set LogLevel VERBOSE"
systemctl reload sshd 2>/dev/null
echo " - Reloaded sshd"
