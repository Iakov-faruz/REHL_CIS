#!/usr/bin/env bash
# CIS 3.3.3 - Ensure bogus icmp responses are ignored (Audit)
check_sysctl() {
    local PARAM="$1"; local EXPECTED="$2"
    local CURRENT=$(sysctl "$PARAM" 2>/dev/null | awk -F= '{print $2}' | xargs)
    [ "$CURRENT" = "$EXPECTED" ] && echo " - PASS: $PARAM=$CURRENT" || echo " - FAIL: $PARAM=$CURRENT (expected $EXPECTED)"
    grep -Pqs "^\h*$PARAM\h*=\h*$EXPECTED\b" /etc/sysctl.conf /etc/sysctl.d/*.conf 2>/dev/null && echo " - PASS: $PARAM in config" || echo " - FAIL: $PARAM NOT in config"
}
echo "=== CIS 3.3.3 - Bogus ICMP ==="
check_sysctl "net.ipv4.icmp_ignore_bogus_error_responses" "1"
