#!/usr/bin/env bash
# CIS 2.4.2.1 - Ensure at is restricted to authorized users (Audit)
echo "=== Checking at.allow and at.deny ==="
if [ -e "/etc/at.deny" ]; then
    echo " - FAIL: /etc/at.deny exists. It should be removed."
else
    echo " - PASS: /etc/at.deny does not exist"
fi

FILE="/etc/at.allow"
if [ -e "$FILE" ]; then
    PERMS=$(stat -Lc '%a' "$FILE")
    UID=$(stat -Lc '%u' "$FILE")
    GID=$(stat -Lc '%g' "$FILE")
    
    # Check if daemon group exists, otherwise it should be root:root
    if getent group daemon >/dev/null; then
        EXPECTED_GID=$(getent group daemon | cut -d: -f3)
        EXPECTED_GNAME="daemon"
    else
        EXPECTED_GID=0
        EXPECTED_GNAME="root"
    fi

    if [ "$UID" -eq 0 ] && [ "$GID" -eq "$EXPECTED_GID" ] && [ "$((PERMS & 0137))" -eq 0 ]; then
        echo " - PASS: $FILE perms and ownership are correct (root:$EXPECTED_GNAME)"
    else
        echo " - FAIL: $FILE permissions=$PERMS uid=$UID gid=$GID (should be 640 or more restrictive, owned by root:$EXPECTED_GNAME)"
    fi
else
    echo " - FAIL: $FILE does not exist. It must exist to restrict at access."
fi
