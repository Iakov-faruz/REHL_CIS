#!/usr/bin/env bash
# CIS 3.3.9 - Ensure suspicious packets are logged (Audit)
check_sysctl() {
    local PARAM="$1"; local EXPECTED="$2"
    local CURRENT=$(sysctl "$PARAM" 2>/dev/null | awk -F= '{print $2}' | xargs)
    [ "$CURRENT" = "$EXPECTED" ] && echo " - PASS: $PARAM=$CURRENT" || echo " - FAIL: $PARAM=$CURRENT (expected $EXPECTED)"
    grep -Pqs "^\h*$PARAM\h*=\h*$EXPECTED\b" /etc/sysctl.conf /etc/sysctl.d/*.conf 2>/dev/null && echo " - PASS: $PARAM in config" || echo " - FAIL: $PARAM NOT in config"
}
echo "=== CIS 3.3.9 - Log Suspicious Packets (Martians) ==="
check_sysctl "net.ipv4.conf.all.log_martians" "1"
check_sysctl "net.ipv4.conf.default.log_martians" "1"
