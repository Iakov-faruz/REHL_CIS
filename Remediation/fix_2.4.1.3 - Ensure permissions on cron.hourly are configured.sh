#!/usr/bin/env bash
# CIS 2.4.1.3 - Ensure permissions on /etc/cron.hourly are configured (Remediation)
DIR="/etc/cron.hourly/"
if [ -d "$DIR" ]; then
    echo "=== CIS 2.4.1.3 - Fixing $DIR permissions ==="
    chown root:root "$DIR"
    chmod og-rwx "$DIR"
    echo " - Fixed: chown root:root $DIR; chmod og-rwx $DIR"
fi
