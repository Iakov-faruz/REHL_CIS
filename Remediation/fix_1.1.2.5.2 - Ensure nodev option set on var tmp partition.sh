#!/usr/bin/env bash
# IF: a separate partition exists for /var/tmp.
# Edit /etc/fstab and add nodev to the fourth field (mounting options) for /var/tmp.
# Example:
#   <device> /var/tmp <fstype> defaults,rw,nosuid,nodev,noexec,relatime 0 0

FSTAB="/etc/fstab"

if grep -Eq '^[^#].*\s/var/tmp\s' "$FSTAB"; then
    if ! grep -Eq '^[^#].*\s/var/tmp\s.*nodev' "$FSTAB"; then
        sed -i '/^[^#].*\s\/var\/tmp\s/ s/\(defaults[^,]*\)/\1,nodev/' "$FSTAB"
    fi
fi

mount -o remount /var/tmp
