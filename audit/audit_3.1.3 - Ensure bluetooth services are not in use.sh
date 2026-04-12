#!/usr/bin/env bash
# CIS 3.1.3 - Ensure bluetooth services are not in use (Audit)
PKG="bluez"
SVC="bluetooth.service"
if ! rpm -q "$PKG" &>/dev/null; then
    echo " - PASS: $PKG is not installed"
    exit 0
fi

echo " - INFO: $PKG is installed"
ENABLED=$(systemctl is-enabled "$SVC" 2>/dev/null)
ACTIVE=$(systemctl is-active "$SVC" 2>/dev/null)
if [ "$ENABLED" = "masked" ] && [ "$ACTIVE" != "active" ]; then
    echo " - PASS: $SVC is masked and not active"
else
    echo " - FAIL: $SVC enabled=$ENABLED active=$ACTIVE"
fi
