#!/usr/bin/env bash
# CIS 1.5.1 - Ensure address space layout randomization is enabled (Audit)
PARAM="kernel.randomize_va_space"
EXPECTED="2"

CURRENT=$(sysctl "$PARAM" 2>/dev/null | awk -F= '{print $2}' | xargs)
if [ "$CURRENT" = "$EXPECTED" ]; then
    echo " - PASS: $PARAM is set to $CURRENT in the running configuration"
else
    echo " - FAIL: $PARAM is set to \"$CURRENT\" - expected \"$EXPECTED\""
fi

# Check persistent config files
if grep -Pqs "^\h*$PARAM\h*=\h*$EXPECTED\b" /etc/sysctl.conf /etc/sysctl.d/*.conf 2>/dev/null; then
    echo " - PASS: $PARAM = $EXPECTED is set in a persistent sysctl config file"
else
    echo " - FAIL: $PARAM = $EXPECTED is NOT set in any persistent sysctl config file"
fi
