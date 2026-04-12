#!/usr/bin/env bash
# CIS 6.3.1.4 - Ensure audit_backlog_limit is sufficient
echo "=== CIS 6.3.1.4 - Ensure audit_backlog_limit is sufficient ==="
grubby --update-kernel=ALL --args="audit_backlog_limit=8192" 
echo "[DONE] Remediation complete"
