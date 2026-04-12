#!/usr/bin/env bash
# IF: a separate partition exists for /var.
# Edit /etc/fstab and add nodev to the fourth field (mounting options) for /var.
# Example:
#   <device> /var <fstype> defaults,rw,nosuid,nodev,noexec,relatime 0 0

FSTAB="/etc/fstab"

if grep -Eq '^[^#].*\s/var\s' "$FSTAB"; then
    if ! grep -Eq '^[^#].*\s/var\s.*nodev' "$FSTAB"; then
        sed -i '/^[^#].*\s\/var\s/ s/\(defaults[^,]*\)/\1,nodev/' "$FSTAB"
    fi
fi

mount -o remount /var
