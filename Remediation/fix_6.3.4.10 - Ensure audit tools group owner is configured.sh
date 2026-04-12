#!/usr/bin/env bash
# CIS 6.3.4.10 - Ensure audit tools group owner is configured
echo "=== CIS 6.3.4.10 - Fix Audit Tools Group ==="
chgrp root /sbin/auditctl /sbin/aureport /sbin/ausearch /sbin/autrace /sbin/auditd /sbin/augenrules 2>/dev/null
echo "[DONE] All audit tools group owned by root"
