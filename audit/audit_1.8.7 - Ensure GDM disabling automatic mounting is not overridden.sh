#!/usr/bin/env bash
# CIS 1.8.7 - Ensure GDM disabling automatic mounting is not overridden (Audit)

if ! rpm -q gdm &>/dev/null; then
    echo " - N/A: gdm is not installed - skipping"
    exit 0
fi

LOCK_FILE="/etc/dconf/db/local.d/locks/00-media-automount"

echo "=== Checking GDM automount lock settings ==="
for setting in automount automount-open; do
    if grep -Pqs "^\h*/org/gnome/desktop/media-handling/$setting\b" "$LOCK_FILE" 2>/dev/null; then
        echo " - PASS: $setting is locked in $LOCK_FILE"
    else
        echo " - FAIL: $setting is NOT locked in $LOCK_FILE"
    fi
done
