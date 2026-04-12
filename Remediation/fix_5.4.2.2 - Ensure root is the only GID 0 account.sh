#!/usr/bin/env bash
# CIS 5.4.2.2 - Ensure root is the only GID 0 account
echo "=== CIS 5.4.2.2 - Ensure root is the only GID 0 account ==="
usermod -g 0 root
echo "[DONE] Remediation complete"
