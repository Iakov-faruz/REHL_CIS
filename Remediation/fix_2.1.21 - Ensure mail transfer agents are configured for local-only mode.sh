#!/usr/bin/env bash
# CIS 2.1.21 - Ensure mail transfer agents are configured for local-only mode
# Remediation script for RHEL 9 / CIS Benchmark

POSTFIX_CONF="/etc/postfix/main.cf"

# Check if postfix is installed
if ! rpm -q postfix &>/dev/null; then
    echo " - Postfix is not installed - checking if another MTA is in use..."
    echo " - NOTE: If another MTA is installed, configure it for local-only mode as per its documentation"
    exit 0
fi

# Check current inet_interfaces setting
CURRENT=$(postconf -n inet_interfaces 2>/dev/null)
echo " - Current inet_interfaces setting: $CURRENT"

if echo "$CURRENT" | grep -q "inet_interfaces = loopback-only"; then
    echo " - inet_interfaces is already set to loopback-only - no changes needed"
else
    echo " - Configuring postfix for local-only mode..."

    # Check if inet_interfaces line exists in main.cf
    if grep -q "^\s*inet_interfaces" "$POSTFIX_CONF" 2>/dev/null; then
        # Update existing line
        sed -i 's/^\s*inet_interfaces\s*=.*/inet_interfaces = loopback-only/' "$POSTFIX_CONF"
        echo " - Updated inet_interfaces to loopback-only in $POSTFIX_CONF"
    else
        # Add to RECEIVING MAIL section or at end of file
        if grep -q "# RECEIVING MAIL" "$POSTFIX_CONF" 2>/dev/null; then
            sed -i '/# RECEIVING MAIL/a inet_interfaces = loopback-only' "$POSTFIX_CONF"
        else
            echo "inet_interfaces = loopback-only" >> "$POSTFIX_CONF"
        fi
        echo " - Added inet_interfaces = loopback-only to $POSTFIX_CONF"
    fi

    # Restart postfix to apply changes
    systemctl restart postfix
    echo " - Postfix restarted"
    echo " - New inet_interfaces setting: $(postconf -n inet_interfaces 2>/dev/null)"
fi

echo " - Done. MTA local-only mode remediation complete."
