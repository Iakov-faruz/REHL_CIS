#!/usr/bin/env bash
# CIS 3.2.1 - Ensure dccp kernel module is not available (Remediation)
MODULE="dccp"
CONF_FILE="/etc/modprobe.d/cis_$MODULE.conf"
echo "=== CIS 3.2.1 - Disabling $MODULE ==="
echo "install $MODULE /bin/false" > "$CONF_FILE"
echo "blacklist $MODULE" >> "$CONF_FILE"
echo " - Configured $CONF_FILE"

if lsmod | grep -q "^$MODULE "; then
    modprobe -r "$MODULE" 2>/dev/null || rmmod "$MODULE" 2>/dev/null
    echo " - Unloaded $MODULE"
fi
