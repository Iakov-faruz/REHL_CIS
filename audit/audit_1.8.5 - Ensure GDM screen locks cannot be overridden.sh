#!/usr/bin/env bash
# CIS 1.8.5 - Ensure GDM screen locks cannot be overridden (Audit)

if ! rpm -q gdm &>/dev/null; then
    echo " - N/A: gdm is not installed - skipping"
    exit 0
fi

LOCK_FILE="/etc/dconf/db/local.d/locks/00-screensaver"

echo "=== Checking GDM screen lock override prevention ==="
for setting in idle-delay lock-delay; do
    if grep -Pqs "^\h*/org/gnome/desktop/session/$setting\b" "$LOCK_FILE" 2>/dev/null || \
       grep -Pqs "^\h*/org/gnome/desktop/screensaver/$setting\b" "$LOCK_FILE" 2>/dev/null; then
        echo " - PASS: $setting is locked in $LOCK_FILE"
    else
        echo " - FAIL: $setting is NOT locked in $LOCK_FILE"
    fi
done
