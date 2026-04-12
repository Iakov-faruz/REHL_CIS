#!/usr/bin/env bash
# CIS 5.4.2.6 - Ensure root user umask is configured
echo "=== CIS 5.4.2.6 - Ensure root user umask is configured ==="
sed -ri 's/^\s*(umask\s+[0-7]+)/#\1/' /root/.bash_profile /root/.bashrc 2>/dev/null
echo "[DONE] Remediation complete"
