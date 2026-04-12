#!/usr/bin/env bash
# CIS 3.3.5 - Ensure icmp redirects are not accepted (Remediation)
CONF_IPV4="/etc/sysctl.d/60-netipv4_sysctl.conf"
CONF_IPV6="/etc/sysctl.d/60-netipv6_sysctl.conf"
echo "=== CIS 3.3.5 - Disabling ICMP Redirects ==="

for PARAM in net.ipv4.conf.all.accept_redirects net.ipv4.conf.default.accept_redirects; do
    sysctl -w $PARAM=0 2>/dev/null
    grep -q "^$PARAM" "$CONF_IPV4" 2>/dev/null && sed -i "s/^.*$PARAM.*/$PARAM = 0/" "$CONF_IPV4" || echo "$PARAM = 0" >> "$CONF_IPV4"
done
sysctl -w net.ipv4.route.flush=1 2>/dev/null

if [ -d /proc/sys/net/ipv6 ]; then
    for PARAM in net.ipv6.conf.all.accept_redirects net.ipv6.conf.default.accept_redirects; do
        sysctl -w $PARAM=0 2>/dev/null
        grep -q "^$PARAM" "$CONF_IPV6" 2>/dev/null && sed -i "s/^.*$PARAM.*/$PARAM = 0/" "$CONF_IPV6" || echo "$PARAM = 0" >> "$CONF_IPV6"
    done
    sysctl -w net.ipv6.route.flush=1 2>/dev/null
fi
echo " - Fixed: accept_redirects disabled"
