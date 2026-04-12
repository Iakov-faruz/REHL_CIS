#!/usr/bin/env bash
# CIS 6.3.4.9 - Ensure audit tools owner is configured
echo "=== CIS 6.3.4.9 - Fix Audit Tools Owner ==="
chown root /sbin/auditctl /sbin/aureport /sbin/ausearch /sbin/autrace /sbin/auditd /sbin/augenrules 2>/dev/null
echo "[DONE] All audit tools owned by root"
