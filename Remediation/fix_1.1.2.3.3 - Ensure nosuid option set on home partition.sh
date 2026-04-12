#!/usr/bin/env bash
# IF: a separate partition exists for /home.
# Edit /etc/fstab and add nosuid to the fourth field (mounting options) for /home.
# Example:
#   <device> /home <fstype> defaults,rw,nosuid,nodev,noexec,relatime 0 0

FSTAB="/etc/fstab"

if grep -Eq '^[^#].*\s/home\s' "$FSTAB"; then
    if ! grep -Eq '^[^#].*\s/home\s.*nosuid' "$FSTAB"; then
        sed -i '/^[^#].*\s\/home\s/ s/\(defaults[^,]*\)/\1,nosuid/' "$FSTAB"
    fi
fi

mount -o remount /home
