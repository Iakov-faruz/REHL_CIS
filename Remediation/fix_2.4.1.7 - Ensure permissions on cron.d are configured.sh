#!/usr/bin/env bash
# CIS 2.4.1.7 - Ensure permissions on /etc/cron.d are configured (Remediation)
DIR="/etc/cron.d/"
if [ -d "$DIR" ]; then
    echo "=== CIS 2.4.1.7 - Fixing $DIR permissions ==="
    chown root:root "$DIR"
    chmod og-rwx "$DIR"
    echo " - Fixed: chown root:root $DIR; chmod og-rwx $DIR"
fi
