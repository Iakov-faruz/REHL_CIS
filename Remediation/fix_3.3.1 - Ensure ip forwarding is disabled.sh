#!/usr/bin/env bash
# CIS 3.3.1 - Ensure ip forwarding is disabled (Remediation)

CONF_IPV4="/etc/sysctl.d/60-netipv4_sysctl.conf"
CONF_IPV6="/etc/sysctl.d/60-netipv6_sysctl.conf"

echo "=== CIS 3.3.1 - Disabling IP Forwarding ==="

sysctl -w net.ipv4.ip_forward=0 2>/dev/null
sysctl -w net.ipv4.route.flush=1 2>/dev/null
grep -q "net.ipv4.ip_forward" "$CONF_IPV4" 2>/dev/null && sed -i 's/^.*net.ipv4.ip_forward.*/net.ipv4.ip_forward = 0/' "$CONF_IPV4" || echo "net.ipv4.ip_forward = 0" >> "$CONF_IPV4"
echo " - IPv4 forwarding disabled"

if [ -d /proc/sys/net/ipv6 ]; then
    sysctl -w net.ipv6.conf.all.forwarding=0 2>/dev/null
    sysctl -w net.ipv6.route.flush=1 2>/dev/null
    grep -q "net.ipv6.conf.all.forwarding" "$CONF_IPV6" 2>/dev/null && sed -i 's/^.*net.ipv6.conf.all.forwarding.*/net.ipv6.conf.all.forwarding = 0/' "$CONF_IPV6" || echo "net.ipv6.conf.all.forwarding = 0" >> "$CONF_IPV6"
    echo " - IPv6 forwarding disabled"
fi
