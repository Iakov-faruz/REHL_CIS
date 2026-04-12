#!/usr/bin/env bash
# CIS 1.5.2 - Ensure ptrace_scope is restricted (Audit)
PARAM="kernel.yama.ptrace_scope"
EXPECTED="1"

CURRENT=$(sysctl "$PARAM" 2>/dev/null | awk -F= '{print $2}' | xargs)
if [ "$CURRENT" = "$EXPECTED" ]; then
    echo " - PASS: $PARAM is set to $CURRENT in the running configuration"
else
    echo " - FAIL: $PARAM is set to \"$CURRENT\" - expected \"$EXPECTED\""
fi

if grep -Pqs "^\h*$PARAM\h*=\h*$EXPECTED\b" /etc/sysctl.conf /etc/sysctl.d/*.conf 2>/dev/null; then
    echo " - PASS: $PARAM = $EXPECTED is set in a persistent sysctl config file"
else
    echo " - FAIL: $PARAM = $EXPECTED is NOT set in any persistent sysctl config file"
fi
