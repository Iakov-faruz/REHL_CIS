#!/usr/bin/env bash
# CIS 1.7.2 - Ensure local login warning banner is configured properly
# Remediation script for RHEL 9 / CIS Benchmark

ISSUE_FILE="/etc/issue"
BANNER_TEXT="Authorized uses only. All activity may be monitored and reported."

# Check if /etc/issue contains system information
if grep -E -i "(\\\v|\\\r|\\\m|\\\s|$(grep '^ID=' /etc/os-release | cut -d= -f2 | sed -e 's/"//g'))" "$ISSUE_FILE" 2>/dev/null; then
    echo " - /etc/issue contains system information - replacing with secure banner"
    echo "$BANNER_TEXT" > "$ISSUE_FILE"
    echo " - /etc/issue has been updated with secure banner"
else
    if [ ! -f "$ISSUE_FILE" ] || [ ! -s "$ISSUE_FILE" ]; then
        echo " - /etc/issue is empty or missing - creating with secure banner"
        echo "$BANNER_TEXT" > "$ISSUE_FILE"
    else
        echo " - /etc/issue does not contain system information - no content changes needed"
        echo " - Please verify content matches local site policy"
    fi
fi

# Set correct permissions
if [ -f "$ISSUE_FILE" ]; then
    echo " - Setting correct permissions on $ISSUE_FILE"
    chown root:root "$(readlink -e $ISSUE_FILE)" 2>/dev/null || true
    chmod u-x,go-wx "$(readlink -e $ISSUE_FILE)" 2>/dev/null || true
    echo " - Permissions set on $ISSUE_FILE"
fi

echo " - Done. Local login banner remediation complete."
