#!/usr/bin/env bash
# CIS 2.4.2.1 - Ensure at is restricted to authorized users (Remediation)
echo "=== CIS 2.4.2.1 - Restricting at ==="
if [ -e "/etc/at.deny" ]; then
    rm -f /etc/at.deny
    echo " - Removed /etc/at.deny"
fi

FILE="/etc/at.allow"
if [ ! -e "$FILE" ]; then
    touch "$FILE"
    echo " - Created $FILE"
fi

if getent group daemon >/dev/null; then
    chown root:daemon "$FILE"
    echo " - Fixed: chown root:daemon $FILE"
else
    chown root:root "$FILE"
    echo " - Fixed: chown root:root $FILE"
fi

chmod u-x,g-wx,o-rwx "$FILE"
echo " - Fixed: chmod 640 $FILE"
