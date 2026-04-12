#!/usr/bin/env bash
# CIS 1.7.4 - Ensure access to /etc/motd is configured (Audit)
FILE="/etc/motd"

if [ -f "$FILE" ]; then
    RESULT=$(stat -Lc 'Access: (%a/%A) Uid: ( %u/ %U) Gid: ( %g/ %G)' "$FILE")
    echo " - $FILE: $RESULT"
    PERMS=$(stat -Lc '%a' "$FILE")
    UID=$(stat -Lc '%u' "$FILE")
    GID=$(stat -Lc '%g' "$FILE")
    if [ "$UID" -eq 0 ] && [ "$GID" -eq 0 ] && [ "$((PERMS & 0133))" -eq 0 ]; then
        echo " - PASS: $FILE ownership and permissions are correctly configured"
    else
        echo " - FAIL: $FILE should be owned by root:root with permissions 644 or more restrictive (no exec, no write for g/o)"
    fi
else
    echo " - WARN: $FILE does not exist - nothing to check"
fi
