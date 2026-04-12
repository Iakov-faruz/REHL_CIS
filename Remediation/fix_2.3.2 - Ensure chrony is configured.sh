#!/usr/bin/env bash
# CIS 2.3.2 - Ensure chrony is configured
# Remediation script for RHEL 9 / CIS Benchmark

CHRONY_CONF="/etc/chrony.conf"
CHRONY_DIR="/etc/chrony.d"

# Check if chrony is installed
if ! rpm -q chrony &>/dev/null; then
    echo " - chrony is not installed. Please run fix_2.3.1 first."
    exit 1
fi

# Check if a remote server is already configured
if grep -Prs -- '^\h*(server|pool)\h+[^#\n\r]+' "$CHRONY_CONF" "$CHRONY_DIR/" 2>/dev/null; then
    echo " - Remote time server(s) are already configured - no changes needed"
    echo " - Current servers:"
    grep -Prs -- '^\h*(server|pool)\h+[^#\n\r]+' "$CHRONY_CONF" "$CHRONY_DIR/" 2>/dev/null
else
    echo " - No remote time servers configured in chrony"
    echo ""
    echo " - MANUAL ACTION REQUIRED:"
    echo "   Add one or more server or pool lines to $CHRONY_CONF"
    echo "   Example:"
    echo "   server <remote-server>"
    echo "   Or using a pool:"
    echo "   pool 2.rhel.pool.ntp.org iburst"
    echo ""
    echo " - Adding a default NTP pool configuration..."
    if ! grep -q "pool 2.rhel.pool.ntp.org" "$CHRONY_CONF" 2>/dev/null; then
        echo "pool 2.rhel.pool.ntp.org iburst" >> "$CHRONY_CONF"
        echo " - Added default NTP pool to $CHRONY_CONF"
        echo " - Please update this with your organization's NTP servers"
    fi

    # Restart chrony to apply configuration
    systemctl restart chronyd 2>/dev/null && echo " - chronyd restarted" || true
fi

echo " - Done. chrony configuration remediation complete."
