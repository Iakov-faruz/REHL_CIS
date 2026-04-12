#!/usr/bin/env bash
# CIS 2.4.1.2 - Ensure permissions on /etc/crontab are configured (Audit)
FILE="/etc/crontab"
if [ -f "$FILE" ]; then
    PERMS=$(stat -Lc '%a' "$FILE")
    UID=$(stat -Lc '%u' "$FILE")
    GID=$(stat -Lc '%g' "$FILE")
    if [ "$UID" -eq 0 ] && [ "$GID" -eq 0 ] && [ "$((PERMS & 0177))" -eq 0 ]; then
        echo " - PASS: $FILE perms and ownership are correct"
    else
        echo " - FAIL: $FILE permissions=$PERMS uid=$UID gid=$GID (should be 600 or more restrictive, owned by root:root)"
    fi
else
    echo " - PASS: $FILE does not exist"
fi
