#!/usr/bin/env bash
# CIS 3.3.3 - Ensure bogus icmp responses are ignored (Remediation)
CONF="/etc/sysctl.d/60-netipv4_sysctl.conf"
PARAM="net.ipv4.icmp_ignore_bogus_error_responses"
echo "=== CIS 3.3.3 - Ignoring bogus ICMP ==="
sysctl -w $PARAM=1 2>/dev/null
sysctl -w net.ipv4.route.flush=1 2>/dev/null
grep -q "^$PARAM" "$CONF" 2>/dev/null && sed -i "s/^.*$PARAM.*/$PARAM = 1/" "$CONF" || echo "$PARAM = 1" >> "$CONF"
echo " - Fixed: icmp_ignore_bogus_error_responses=1"
