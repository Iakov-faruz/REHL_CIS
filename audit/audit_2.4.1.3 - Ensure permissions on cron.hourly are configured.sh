#!/usr/bin/env bash
# CIS 2.4.1.3 - Ensure permissions on /etc/cron.hourly are configured (Audit)
DIR="/etc/cron.hourly"
if [ -d "$DIR" ]; then
    PERMS=$(stat -Lc '%a' "$DIR")
    UID=$(stat -Lc '%u' "$DIR")
    GID=$(stat -Lc '%g' "$DIR")
    if [ "$UID" -eq 0 ] && [ "$GID" -eq 0 ] && [ "$((PERMS & 0022))" -eq 0 ]; then
        echo " - PASS: $DIR perms and ownership are correct"
    else
        echo " - FAIL: $DIR permissions=$PERMS uid=$UID gid=$GID (should be 755 or more restrictive, owned by root:root)"
    fi
else
    echo " - PASS: $DIR does not exist"
fi
