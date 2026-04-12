#!/usr/bin/env bash
# IF: a separate partition exists for /tmp.
# Edit /etc/fstab and add nodev to the fourth field (mounting options) for /tmp.
# Example:
#   <device> /tmp <fstype> defaults,rw,nosuid,nodev,noexec,relatime 0 0

FSTAB="/etc/fstab"

if grep -Eq '^[^#].*\s/tmp\s' "$FSTAB"; then
    if ! grep -Eq '^[^#].*\s/tmp\s.*nodev' "$FSTAB"; then
        sed -i '/^[^#].*\s\/tmp\s/ s/\(defaults[^,]*\)/\1,nodev/' "$FSTAB"
    fi
fi

mount -o remount /tmp
