#!/usr/bin/env bash
# CIS 1.7.3 - Ensure remote login warning banner is configured properly
# Remediation script for RHEL 9 / CIS Benchmark

ISSUE_NET_FILE="/etc/issue.net"
BANNER_TEXT="Authorized uses only. All activity may be monitored and reported."

# Check if /etc/issue.net contains system information
if grep -E -i "(\\\v|\\\r|\\\m|\\\s|$(grep '^ID=' /etc/os-release | cut -d= -f2 | sed -e 's/"//g'))" "$ISSUE_NET_FILE" 2>/dev/null; then
    echo " - /etc/issue.net contains system information - replacing with secure banner"
    echo "$BANNER_TEXT" > "$ISSUE_NET_FILE"
    echo " - /etc/issue.net has been updated with secure banner"
else
    if [ ! -f "$ISSUE_NET_FILE" ] || [ ! -s "$ISSUE_NET_FILE" ]; then
        echo " - /etc/issue.net is empty or missing - creating with secure banner"
        echo "$BANNER_TEXT" > "$ISSUE_NET_FILE"
    else
        echo " - /etc/issue.net does not contain system information - no content changes needed"
        echo " - Please verify content matches local site policy"
    fi
fi

# Set correct permissions
if [ -f "$ISSUE_NET_FILE" ]; then
    echo " - Setting correct permissions on $ISSUE_NET_FILE"
    chown root:root "$(readlink -e $ISSUE_NET_FILE)" 2>/dev/null || true
    chmod u-x,go-wx "$(readlink -e $ISSUE_NET_FILE)" 2>/dev/null || true
    echo " - Permissions set on $ISSUE_NET_FILE"
fi

echo " - Done. Remote login banner remediation complete."
