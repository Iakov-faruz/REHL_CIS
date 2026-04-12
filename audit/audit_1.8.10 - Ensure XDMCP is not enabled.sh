#!/usr/bin/env bash
# CIS 1.8.10 - Ensure XDMCP is not enabled (Audit)

GDM_CUSTOM="/etc/gdm/custom.conf"

if [ -f "$GDM_CUSTOM" ]; then
    if grep -Pis '^\h*Enable\h*=\h*true\b' "$GDM_CUSTOM" 2>/dev/null; then
        echo " - FAIL: XDMCP is enabled in $GDM_CUSTOM (Enable=true found under [xdmcp])"
    else
        echo " - PASS: XDMCP is NOT enabled in $GDM_CUSTOM"
    fi
else
    echo " - PASS: $GDM_CUSTOM does not exist - XDMCP is not configured"
fi
