#!/usr/bin/env bash
# CIS 2.4.1.2 - Ensure permissions on /etc/crontab are configured (Remediation)
FILE="/etc/crontab"
if [ -f "$FILE" ]; then
    echo "=== CIS 2.4.1.2 - Fixing $FILE permissions ==="
    chown root:root "$FILE"
    chmod og-rwx "$FILE"
    echo " - Fixed: chown root:root $FILE; chmod og-rwx $FILE"
else
    echo " - INFO: $FILE does not exist"
fi
