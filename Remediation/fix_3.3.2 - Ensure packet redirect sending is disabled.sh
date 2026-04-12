#!/usr/bin/env bash
# CIS 3.3.2 - Ensure packet redirect sending is disabled (Remediation)
CONF="/etc/sysctl.d/60-netipv4_sysctl.conf"
echo "=== CIS 3.3.2 - Disabling packet redirect sending ==="
for PARAM in net.ipv4.conf.all.send_redirects net.ipv4.conf.default.send_redirects; do
    sysctl -w $PARAM=0 2>/dev/null
    grep -q "^$PARAM" "$CONF" 2>/dev/null && sed -i "s/^.*$PARAM.*/$PARAM = 0/" "$CONF" || echo "$PARAM = 0" >> "$CONF"
done
sysctl -w net.ipv4.route.flush=1 2>/dev/null
echo " - Fixed: send_redirects disabled"
