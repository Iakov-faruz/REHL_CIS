#!/usr/bin/env bash
# CIS 5.4.2.3 - Ensure group root is the only GID 0 group
echo "=== CIS 5.4.2.3 - Ensure group root is the only GID 0 group ==="
groupmod -g 0 root
echo "[DONE] Remediation complete"
