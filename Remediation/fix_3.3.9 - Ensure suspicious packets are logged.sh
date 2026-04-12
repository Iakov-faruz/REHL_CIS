#!/usr/bin/env bash
# CIS 3.3.9 - Ensure suspicious packets are logged (Remediation)
CONF="/etc/sysctl.d/60-netipv4_sysctl.conf"
echo "=== CIS 3.3.9 - Enabling log_martians ==="
for PARAM in net.ipv4.conf.all.log_martians net.ipv4.conf.default.log_martians; do
    sysctl -w $PARAM=1 2>/dev/null
    grep -q "^$PARAM" "$CONF" 2>/dev/null && sed -i "s/^.*$PARAM.*/$PARAM = 1/" "$CONF" || echo "$PARAM = 1" >> "$CONF"
done
sysctl -w net.ipv4.route.flush=1 2>/dev/null
echo " - Fixed: log_martians enabled"
