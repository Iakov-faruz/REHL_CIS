#!/usr/bin/env bash
# CIS 3.1.1 - Ensure IPv6 status is identified (Remediation/Manual)
echo "=== CIS 3.1.1 - IPv6 Remediation (Manual) ==="
echo "If your environment does NOT require IPv6, disable it."
echo "Option 1 (sysctl):"
echo "  Add 'net.ipv6.conf.all.disable_ipv6 = 1' and 'net.ipv6.conf.default.disable_ipv6 = 1' to /etc/sysctl.d/60-ipv6.conf"
echo "  sysctl -w net.ipv6.conf.all.disable_ipv6=1"
echo "  sysctl -w net.ipv6.conf.default.disable_ipv6=1"
echo "Option 2 (grub - more robust):"
echo "  Add 'ipv6.disable=1' to GRUB_CMDLINE_LINUX in /etc/default/grub"
echo "  grub2-mkconfig -o /boot/grub2/grub.cfg"
