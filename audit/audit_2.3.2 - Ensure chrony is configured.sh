#!/usr/bin/env bash
# CIS 2.3.2 - Ensure chrony is configured (Audit)

if ! rpm -q chrony &>/dev/null; then
    echo " - N/A: chrony is not installed - run audit_2.3.1 first"
    exit 0
fi

CONF_FILE="/etc/chrony.conf"
CONF_DIR="/etc/chrony.d"

echo "=== Checking chrony time server configuration ==="
if grep -Prs -- '^\h*(server|pool)\h+[^#\n\r]+' "$CONF_FILE" "$CONF_DIR/" 2>/dev/null; then
    echo " - PASS: Remote time server(s) are configured"
else
    echo " - FAIL: No remote server or pool is configured in $CONF_FILE or $CONF_DIR"
fi
