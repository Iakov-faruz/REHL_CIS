#!/usr/bin/env bash
# CIS 5.3.3.2.7 - Ensure password creation requirements are configured - enforce_for_root
echo "=== CIS 5.3.3.2.7 - Ensure password creation requirements are configured - enforce_for_root ==="
echo "enforce_for_root" > /etc/security/pwquality.conf.d/50-pwquality-root.conf
echo "[DONE] Remediation complete"
