#!/usr/bin/env bash
# CIS 3.3.7 - Ensure reverse path filtering is enabled (Remediation)
CONF="/etc/sysctl.d/60-netipv4_sysctl.conf"
echo "=== CIS 3.3.7 - Enabling reverse path filtering ==="
for PARAM in net.ipv4.conf.all.rp_filter net.ipv4.conf.default.rp_filter; do
    sysctl -w $PARAM=1 2>/dev/null
    grep -q "^$PARAM" "$CONF" 2>/dev/null && sed -i "s/^.*$PARAM.*/$PARAM = 1/" "$CONF" || echo "$PARAM = 1" >> "$CONF"
done
sysctl -w net.ipv4.route.flush=1 2>/dev/null
echo " - Fixed: rp_filter enabled"
