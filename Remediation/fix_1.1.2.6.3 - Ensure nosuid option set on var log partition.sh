#!/usr/bin/env bash
# IF: a separate partition exists for /var/log.
# Edit /etc/fstab and add nosuid to the fourth field (mounting options) for /var/log.
# Example:
#   <device> /var/log <fstype> defaults,rw,nosuid,nodev,noexec,relatime 0 0

FSTAB="/etc/fstab"

if grep -Eq '^[^#].*\s/var/log\s' "$FSTAB"; then
    if ! grep -Eq '^[^#].*\s/var/log\s.*nosuid' "$FSTAB"; then
        sed -i '/^[^#].*\s\/var\/log\s/ s/\(defaults[^,]*\)/\1,nosuid/' "$FSTAB"
    fi
fi

mount -o remount /var/log
