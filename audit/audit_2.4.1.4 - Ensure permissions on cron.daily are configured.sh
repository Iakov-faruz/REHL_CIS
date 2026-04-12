#!/usr/bin/env bash
# CIS 2.4.1.4 - Ensure permissions on /etc/cron.daily are configured (Audit)
DIR="/etc/cron.daily"
if [ -d "$DIR" ]; then
    PERMS=$(stat -Lc '%a' "$DIR")
    UID=$(stat -Lc '%u' "$DIR")
    GID=$(stat -Lc '%g' "$DIR")
    if [ "$UID" -eq 0 ] && [ "$GID" -eq 0 ] && [ "$((PERMS & 0022))" -eq 0 ]; then
        echo " - PASS: $DIR perms and ownership are correct"
    else
        echo " - FAIL: $DIR permissions=$PERMS uid=$UID gid=$GID"
    fi
else
    echo " - PASS: $DIR does not exist"
fi
