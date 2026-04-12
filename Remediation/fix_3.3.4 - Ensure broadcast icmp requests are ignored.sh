#!/usr/bin/env bash
# CIS 3.3.4 - Ensure broadcast icmp requests are ignored (Remediation)
CONF="/etc/sysctl.d/60-netipv4_sysctl.conf"
PARAM="net.ipv4.icmp_echo_ignore_broadcasts"
echo "=== CIS 3.3.4 - Ignoring broadcast ICMP ==="
sysctl -w $PARAM=1 2>/dev/null
sysctl -w net.ipv4.route.flush=1 2>/dev/null
grep -q "^$PARAM" "$CONF" 2>/dev/null && sed -i "s/^.*$PARAM.*/$PARAM = 1/" "$CONF" || echo "$PARAM = 1" >> "$CONF"
echo " - Fixed: icmp_echo_ignore_broadcasts=1"
