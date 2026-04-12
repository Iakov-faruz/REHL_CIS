#!/usr/bin/env bash
# CIS 2.4.1.4 - Ensure permissions on /etc/cron.daily are configured (Remediation)
DIR="/etc/cron.daily/"
if [ -d "$DIR" ]; then
    echo "=== CIS 2.4.1.4 - Fixing $DIR permissions ==="
    chown root:root "$DIR"
    chmod og-rwx "$DIR"
    echo " - Fixed: chown root:root $DIR; chmod og-rwx $DIR"
fi
