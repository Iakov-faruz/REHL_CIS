#!/usr/bin/env bash
# IF: a separate partition exists for /var/log/audit.
# Edit /etc/fstab and add nosuid to the fourth field (mounting options) for /var/log/audit.
# Example:
#   <device> /var/log/audit <fstype> defaults,rw,nosuid,nodev,noexec,relatime 0 0

FSTAB="/etc/fstab"

if grep -Eq '^[^#].*\s/var/log/audit\s' "$FSTAB"; then
    if ! grep -Eq '^[^#].*\s/var/log/audit\s.*nosuid' "$FSTAB"; then
        sed -i '/^[^#].*\s\/var\/log\/audit\s/ s/\(defaults[^,]*\)/\1,nosuid/' "$FSTAB"
    fi
fi

mount -o remount /var/log/audit
