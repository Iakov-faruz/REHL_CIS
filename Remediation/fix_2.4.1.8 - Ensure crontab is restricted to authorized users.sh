#!/usr/bin/env bash
# CIS 2.4.1.8 - Ensure crontab is restricted to authorized users (Remediation)
echo "=== CIS 2.4.1.8 - Restricting crontab ==="
if [ -e "/etc/cron.deny" ]; then
    rm -f /etc/cron.deny
    echo " - Removed /etc/cron.deny"
fi

FILE="/etc/cron.allow"
if [ ! -e "$FILE" ]; then
    touch "$FILE"
    echo " - Created $FILE"
fi

chown root:root "$FILE"
chmod u-x,g-wx,o-rwx "$FILE"
echo " - Fixed: chown root:root $FILE; chmod 640 $FILE"
