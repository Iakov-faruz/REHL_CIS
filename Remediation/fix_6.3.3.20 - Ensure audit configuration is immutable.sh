#!/usr/bin/env bash
# CIS 6.3.3.20 - Ensure audit configuration is immutable
echo "=== CIS 6.3.3.20 - Ensure audit configuration is immutable ==="
echo "-e 2" > /etc/audit/rules.d/99-finalize.rules; augenrules --load
echo "[DONE] Remediation complete"
