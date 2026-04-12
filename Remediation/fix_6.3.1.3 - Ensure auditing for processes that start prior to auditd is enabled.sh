#!/usr/bin/env bash
# CIS 6.3.1.3 - Ensure auditing for processes that start prior to auditd is enabled
echo "=== CIS 6.3.1.3 - Ensure auditing for processes that start prior to auditd is enabled ==="
grubby --update-kernel=ALL --args="audit=1" 
echo "[DONE] Remediation complete"
