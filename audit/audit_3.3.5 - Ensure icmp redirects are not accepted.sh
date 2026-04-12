#!/usr/bin/env bash
# CIS 3.3.5 - Ensure icmp redirects are not accepted (Audit)
check_sysctl() {
    local PARAM="$1"; local EXPECTED="$2"
    local CURRENT=$(sysctl "$PARAM" 2>/dev/null | awk -F= '{print $2}' | xargs)
    [ "$CURRENT" = "$EXPECTED" ] && echo " - PASS: $PARAM=$CURRENT" || echo " - FAIL: $PARAM=$CURRENT (expected $EXPECTED)"
    grep -Pqs "^\h*$PARAM\h*=\h*$EXPECTED\b" /etc/sysctl.conf /etc/sysctl.d/*.conf 2>/dev/null && echo " - PASS: $PARAM in config" || echo " - FAIL: $PARAM NOT in config"
}
echo "=== CIS 3.3.5 - ICMP Redirects ==="
check_sysctl "net.ipv4.conf.all.accept_redirects" "0"
check_sysctl "net.ipv4.conf.default.accept_redirects" "0"
if [ -d /proc/sys/net/ipv6 ]; then
    check_sysctl "net.ipv6.conf.all.accept_redirects" "0"
    check_sysctl "net.ipv6.conf.default.accept_redirects" "0"
fi
