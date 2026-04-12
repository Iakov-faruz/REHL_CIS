#!/usr/bin/env bash
# CIS 2.1.22 - Ensure only approved services are listening on a network interface (Manual Audit)
# This is a Manual audit - requires review of listening ports per local site policy

echo "=== CIS 2.1.22 - Ensure only approved services are listening (Manual) ==="
echo ""
echo " - NOTE: This is a MANUAL check. Review the output below against approved services list."
echo ""
echo "=== Listening TCP ports ==="
ss -plntu 2>/dev/null || netstat -plntu 2>/dev/null || echo " - ERROR: ss and netstat not available"
echo ""
echo "=== Processes listening on network sockets ==="
ss -plntu 2>/dev/null | awk 'NR>1 {print $5, $7}' | sort -u || true
echo ""
echo " - Manual action required: Verify each listening port is approved by local site policy"
echo " - Disable/remove any services that are not needed"
