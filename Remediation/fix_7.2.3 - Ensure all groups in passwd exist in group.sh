#!/usr/bin/env bash
# CIS 7.2.3 - Ensure all groups in passwd exist in group file
echo "=== CIS 7.2.3 - Fix Missing Groups ==="
echo "[NOTE] Manually add missing groups with: groupadd <groupname> -g <gid>"
echo "Run the audit script first to identify missing groups."
