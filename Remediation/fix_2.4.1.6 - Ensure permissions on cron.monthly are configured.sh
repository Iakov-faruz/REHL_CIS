#!/usr/bin/env bash
# CIS 2.4.1.6 - Ensure permissions on /etc/cron.monthly are configured (Remediation)
DIR="/etc/cron.monthly/"
if [ -d "$DIR" ]; then
    echo "=== CIS 2.4.1.6 - Fixing $DIR permissions ==="
    chown root:root "$DIR"
    chmod og-rwx "$DIR"
    echo " - Fixed: chown root:root $DIR; chmod og-rwx $DIR"
fi
