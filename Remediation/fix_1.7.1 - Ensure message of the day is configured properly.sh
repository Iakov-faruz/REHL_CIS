#!/usr/bin/env bash
# CIS 1.7.1 - Ensure message of the day is configured properly
# Remediation script for RHEL 9 / CIS Benchmark

MOTD_FILE="/etc/motd"

# Check for system information in MOTD files
HAS_SYSINFO=false
for l_file in /etc/motd /etc/motd.d/*; do
    if [ -f "$l_file" ]; then
        if grep -Psqi -- "(\\\v|\\\r|\\\m|\\\s|\b$(grep ^ID= /etc/os-release | cut -d= -f2 | sed -e 's/"//g')\b)" "$l_file" 2>/dev/null; then
            echo " - WARNING: File $l_file contains system information - please review and edit manually"
            HAS_SYSINFO=true
        fi
    fi
done

if [ "$HAS_SYSINFO" = false ]; then
    echo " - No MOTD files contain system information"
fi

# Ensure /etc/motd exists with correct permissions if it exists
if [ -f "$MOTD_FILE" ]; then
    echo " - Setting correct permissions on $MOTD_FILE"
    chown root:root "$(readlink -e $MOTD_FILE)" 2>/dev/null || true
    chmod u-x,go-wx "$(readlink -e $MOTD_FILE)" 2>/dev/null || true
    echo " - Permissions set on $MOTD_FILE"
fi

echo ""
echo " - NOTE: Please review MOTD content manually to ensure it conforms to local site policy"
echo " - Example content: 'Authorized uses only. All activity may be monitored and reported.'"
echo " - Done. MOTD configuration remediation complete."
