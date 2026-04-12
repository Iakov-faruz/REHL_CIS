#!/usr/bin/env bash
# CIS 3.1.1 - Ensure IPv6 status is identified (Audit/Manual)
echo "=== CIS 3.1.1 - IPv6 Status (Manual check) ==="
echo "If IPv6 is not needed, it should be disabled."

# Check sysctl config
SYSCTL_DISABLE=$(sysctl net.ipv6.conf.all.disable_ipv6 2>/dev/null | awk '{print $3}')
if [ "$SYSCTL_DISABLE" = "1" ]; then
    echo " - INFO: IPv6 appears to be disabled via sysctl (net.ipv6.conf.all.disable_ipv6 = 1)"
else
    echo " - INFO: IPv6 is NOT disabled via net.ipv6.conf.all.disable_ipv6"
fi

# Check kernel parameter
GRUB_IPV6=$(grep -Po '^\h*GRUB_CMDLINE_LINUX="([^#\n\r]+\h+)?ipv6\.disable=1\b' /etc/default/grub 2>/dev/null)
if [ -n "$GRUB_IPV6" ]; then
    echo " - INFO: IPv6 appears to be disabled via grub (ipv6.disable=1)"
else
    echo " - INFO: IPv6 is NOT disabled via grub kernel parameter"
fi
