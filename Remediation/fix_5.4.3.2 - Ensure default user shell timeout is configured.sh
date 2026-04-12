#!/usr/bin/env bash
# CIS 5.4.3.2 - Ensure default user shell timeout is configured
echo "=== CIS 5.4.3.2 - Ensure default user shell timeout is configured ==="
echo "typeset -xr TMOUT=900" > /etc/profile.d/50-tmout.sh
echo "[DONE] Remediation complete"
