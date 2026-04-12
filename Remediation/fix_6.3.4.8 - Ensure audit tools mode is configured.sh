#!/usr/bin/env bash
# CIS 6.3.4.8 - Ensure audit tools mode is configured
echo "=== CIS 6.3.4.8 - Fix Audit Tools Mode ==="
chmod go-w /sbin/auditctl /sbin/aureport /sbin/ausearch /sbin/autrace /sbin/auditd /sbin/augenrules 2>/dev/null
echo "[DONE] Audit tools set to mode 0755 or more restrictive"
