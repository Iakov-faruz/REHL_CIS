#!/usr/bin/env bash
# CIS 3.3.10 - Ensure tcp syn cookies is enabled (Remediation)
CONF="/etc/sysctl.d/60-netipv4_sysctl.conf"
PARAM="net.ipv4.tcp_syncookies"
echo "=== CIS 3.3.10 - Enabling TCP SYN Cookies ==="
sysctl -w $PARAM=1 2>/dev/null
sysctl -w net.ipv4.route.flush=1 2>/dev/null
grep -q "^$PARAM" "$CONF" 2>/dev/null && sed -i "s/^.*$PARAM.*/$PARAM = 1/" "$CONF" || echo "$PARAM = 1" >> "$CONF"
echo " - Fixed: tcp_syncookies=1"
