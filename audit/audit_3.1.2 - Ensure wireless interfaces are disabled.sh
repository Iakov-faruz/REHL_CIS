#!/usr/bin/env bash
# CIS 3.1.2 - Ensure wireless interfaces are disabled (Audit)
echo "=== Checking wireless interfaces ==="
if command -v nmcli >/dev/null 2>&1; then
    WIFIS=$(nmcli radio wifi 2>/dev/null)
    if [ "$WIFIS" = "disabled" ]; then
        echo " - PASS: Wireless is disabled via NetworkManager"
    else
        echo " - FAIL: nmcli radio wifi shows: $WIFIS"
    fi
else
    echo " - INFO: nmcli not found"
fi

MODULES=$(find /sys/class/net/*/wireless 2>/dev/null | awk -F'/' '{print $5}')
if [ -n "$MODULES" ]; then
    echo " - FAIL: Wireless interfaces found on system: $MODULES"
else
    echo " - PASS: No wireless interfaces detected in /sys/class/net/"
fi
