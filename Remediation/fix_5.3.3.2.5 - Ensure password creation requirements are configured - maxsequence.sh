#!/usr/bin/env bash
# CIS 5.3.3.2.5 - Ensure password creation requirements are configured - maxsequence
echo "=== CIS 5.3.3.2.5 - Ensure password creation requirements are configured - maxsequence ==="
echo "maxsequence = 3" > /etc/security/pwquality.conf.d/50-pwquality-maxseq.conf
echo "[DONE] Remediation complete"
