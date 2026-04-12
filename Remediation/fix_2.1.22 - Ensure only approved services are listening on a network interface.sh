#!/usr/bin/env bash
# CIS 2.1.22 - Ensure only approved services are listening on a network interface
# Remediation script for RHEL 9 / CIS Benchmark (Manual)
# This is a MANUAL remediation - requires site-specific decisions

echo "=== CIS 2.1.22 - Ensure only approved services are listening ==="
echo ""
echo " - NOTE: This is a MANUAL remediation recommendation."
echo " - Review each listening service against your approved services list."
echo ""
echo "=== Current listening services ==="
ss -plntu 2>/dev/null || netstat -plntu 2>/dev/null

echo ""
echo "=== Recommended actions ==="
echo " 1. Review all listening ports above"
echo " 2. For any unapproved service, run:"
echo "    systemctl stop <service>"
echo "    systemctl disable <service>"
echo "    systemctl mask <service>"
echo " 3. For any unapproved package that is not needed, run:"
echo "    dnf remove <package>"
echo ""
echo " - Common ports to review:"
echo "   21 - FTP, 23 - Telnet, 25 - SMTP (if not local-only), 53 - DNS"
echo "   80/443 - HTTP/HTTPS, 111 - RPC, 137-139/445 - Samba/SMB"
echo "   2049 - NFS, 3306 - MySQL, 5432 - PostgreSQL"
