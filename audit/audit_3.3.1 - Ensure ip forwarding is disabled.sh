#!/usr/bin/env bash
# CIS 3.3.1 - Ensure ip forwarding is disabled (Audit)

check_sysctl() {
    local PARAM="$1"
    local EXPECTED="$2"
    local CURRENT=$(sysctl "$PARAM" 2>/dev/null | awk -F= '{print $2}' | xargs)
    if [ "$CURRENT" = "$EXPECTED" ]; then
        echo " - PASS: $PARAM is $CURRENT (Active)"
    else
        echo " - FAIL: $PARAM is $CURRENT (Active), expected $EXPECTED"
    fi

    if grep -Pqs "^\h*$PARAM\h*=\h*$EXPECTED\b" /etc/sysctl.conf /etc/sysctl.d/*.conf 2>/dev/null; then
        echo " - PASS: $PARAM=$EXPECTED is set in config files"
    else
        echo " - FAIL: $PARAM=$EXPECTED is NOT set in config files"
    fi
}

echo "=== CIS 3.3.1 - Auditing IP Forwarding ==="
check_sysctl "net.ipv4.ip_forward" "0"

if [ -d /proc/sys/net/ipv6 ]; then
    check_sysctl "net.ipv6.conf.all.forwarding" "0"
fi
