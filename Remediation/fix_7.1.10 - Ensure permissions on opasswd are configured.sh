#!/usr/bin/env bash
# CIS 7.1.10 - Ensure permissions on /etc/security/opasswd are configured
echo "=== CIS 7.1.10 - Fix /etc/security/opasswd ==="
[ -e /etc/security/opasswd ] && chmod u-x,go-rwx /etc/security/opasswd && chown root:root /etc/security/opasswd
[ -e /etc/security/opasswd.old ] && chmod u-x,go-rwx /etc/security/opasswd.old && chown root:root /etc/security/opasswd.old
echo "[DONE] opasswd permissions fixed"
