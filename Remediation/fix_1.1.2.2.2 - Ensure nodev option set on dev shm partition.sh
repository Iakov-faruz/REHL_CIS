#!/usr/bin/env bash
# IF: a separate partition exists for /dev/shm.
# Edit /etc/fstab and add nodev to the fourth field (mounting options) for /dev/shm.
# Example:
#   tmpfs /dev/shm tmpfs defaults,rw,nosuid,nodev,noexec,relatime 0 0

FSTAB="/etc/fstab"

if grep -Eq '^[^#].*\s/dev/shm\s' "$FSTAB"; then
    if ! grep -Eq '^[^#].*\s/dev/shm\s.*nodev' "$FSTAB"; then
        sed -i '/^[^#].*\s\/dev\/shm\s/ s/\(defaults[^,]*\)/\1,nodev/' "$FSTAB"
    fi
fi

mount -o remount /dev/shm
