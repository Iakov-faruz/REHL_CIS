#!/usr/bin/env bash
# CIS 3.3.6 - Ensure secure icmp redirects are not accepted (Remediation)
CONF="/etc/sysctl.d/60-netipv4_sysctl.conf"
echo "=== CIS 3.3.6 - Disabling secure ICMP Redirects ==="
for PARAM in net.ipv4.conf.all.secure_redirects net.ipv4.conf.default.secure_redirects; do
    sysctl -w $PARAM=0 2>/dev/null
    grep -q "^$PARAM" "$CONF" 2>/dev/null && sed -i "s/^.*$PARAM.*/$PARAM = 0/" "$CONF" || echo "$PARAM = 0" >> "$CONF"
done
sysctl -w net.ipv4.route.flush=1 2>/dev/null
echo " - Fixed: secure_redirects disabled"
