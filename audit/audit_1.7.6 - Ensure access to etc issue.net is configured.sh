#!/usr/bin/env bash
# CIS 1.7.6 - Ensure access to /etc/issue.net is configured (Audit)
FILE="/etc/issue.net"

if [ -f "$FILE" ]; then
    RESULT=$(stat -Lc 'Access: (%a/%A) Uid: ( %u/ %U) Gid: ( %g/ %G)' "$FILE")
    echo " - $FILE: $RESULT"
    PERMS=$(stat -Lc '%a' "$FILE")
    UID=$(stat -Lc '%u' "$FILE")
    GID=$(stat -Lc '%g' "$FILE")
    if [ "$UID" -eq 0 ] && [ "$GID" -eq 0 ] && [ "$((PERMS & 0133))" -eq 0 ]; then
        echo " - PASS: $FILE ownership and permissions are correctly configured"
    else
        echo " - FAIL: $FILE should be owned by root:root with permissions 644 or more restrictive"
    fi
else
    echo " - FAIL: $FILE does not exist"
fi
