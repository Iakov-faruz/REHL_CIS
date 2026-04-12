#!/usr/bin/env bash
# CIS 1.5.2 - Ensure ptrace_scope is restricted
# Remediation script for RHEL 9 / CIS Benchmark

PARAM="kernel.yama.ptrace_scope"
VALUE="1"
CONF_FILE="/etc/sysctl.d/60-kernel_sysctl.conf"

# Check if already set correctly in running config
CURRENT=$(sysctl "$PARAM" 2>/dev/null | awk -F= '{print $2}' | xargs)
if [ "$CURRENT" = "$VALUE" ]; then
    echo " - $PARAM is already set to $VALUE in the running configuration"
else
    echo " - Setting $PARAM to $VALUE in running configuration"
    sysctl -w "$PARAM=$VALUE"
fi

# Check if set in a config file
if grep -Pqs "^\h*$PARAM\h*=\h*$VALUE\b" /etc/sysctl.conf /etc/sysctl.d/*.conf 2>/dev/null; then
    echo " - $PARAM is already set to $VALUE in a sysctl config file"
else
    echo " - Adding $PARAM = $VALUE to $CONF_FILE"
    # Remove any existing (possibly incorrect) entries
    sed -i "/^\s*${PARAM}\s*=/d" "$CONF_FILE" 2>/dev/null || true
    printf '\n%s = %s\n' "$PARAM" "$VALUE" >> "$CONF_FILE"
fi

echo " - Done. ptrace_scope remediation complete."
