#!/usr/bin/env bash
# CIS 2.4.1.5 - Ensure permissions on /etc/cron.weekly are configured (Remediation)
DIR="/etc/cron.weekly/"
if [ -d "$DIR" ]; then
    echo "=== CIS 2.4.1.5 - Fixing $DIR permissions ==="
    chown root:root "$DIR"
    chmod og-rwx "$DIR"
    echo " - Fixed: chown root:root $DIR; chmod og-rwx $DIR"
fi
