#!/usr/bin/env bash
# CIS 6.3.3.21 - Ensure running and on disk configuration is the same
echo "=== CIS 6.3.3.21 - Ensure running and on disk configuration is the same ==="
augenrules --load
echo "[DONE] Remediation complete"
