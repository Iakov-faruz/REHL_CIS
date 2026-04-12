#!/usr/bin/env bash
# CIS 1.8.9 - Ensure GDM autorun-never is not overridden (Audit)

if ! rpm -q gdm &>/dev/null; then
    echo " - N/A: gdm is not installed - skipping"
    exit 0
fi

LOCK_FILE="/etc/dconf/db/local.d/locks/00-media-automount"

if grep -Pqs '^\h*/org/gnome/desktop/media-handling/autorun-never\b' "$LOCK_FILE" 2>/dev/null; then
    echo " - PASS: autorun-never is locked in $LOCK_FILE"
else
    echo " - FAIL: autorun-never is NOT locked in $LOCK_FILE"
fi
