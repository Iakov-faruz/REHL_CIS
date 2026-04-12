#!/usr/bin/env bash
# CIS 2.4.1.8 - Ensure crontab is restricted to authorized users (Audit)
echo "=== Checking cron.allow and cron.deny ==="
if [ -e "/etc/cron.deny" ]; then
    echo " - FAIL: /etc/cron.deny exists. It should be removed."
else
    echo " - PASS: /etc/cron.deny does not exist"
fi

FILE="/etc/cron.allow"
if [ -e "$FILE" ]; then
    PERMS=$(stat -Lc '%a' "$FILE")
    UID=$(stat -Lc '%u' "$FILE")
    GID=$(stat -Lc '%g' "$FILE")
    if [ "$UID" -eq 0 ] && [ "$GID" -eq 0 ] && [ "$((PERMS & 0137))" -eq 0 ]; then
        echo " - PASS: $FILE perms and ownership are correct"
    else
        echo " - FAIL: $FILE permissions=$PERMS uid=$UID gid=$GID (should be 640 or more restrictive, owned by root:root)"
    fi
else
    echo " - FAIL: $FILE does not exist. It must exist to restrict cron access."
fi
