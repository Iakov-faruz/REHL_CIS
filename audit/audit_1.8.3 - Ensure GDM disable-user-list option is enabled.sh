#!/usr/bin/env bash
# CIS 1.8.3 - Ensure GDM disable-user-list option is enabled (Audit)

if ! rpm -q gdm &>/dev/null; then
    echo " - N/A: gdm is not installed - skipping"
    exit 0
fi

GDM_CONF="/etc/dconf/db/gdm.d/00-login-screen"
LOCK_FILE="/etc/dconf/db/gdm.d/locks/00-login-screen"

if grep -Pqs '^\h*disable-user-list\h*=\h*true\b' "$GDM_CONF" 2>/dev/null; then
    echo " - PASS: disable-user-list = true is set in $GDM_CONF"
else
    echo " - FAIL: disable-user-list = true is NOT set in $GDM_CONF"
fi

if grep -Pqs '^\h*/org/gnome/login-screen/disable-user-list\b' "$LOCK_FILE" 2>/dev/null; then
    echo " - PASS: disable-user-list is locked in $LOCK_FILE"
else
    echo " - FAIL: disable-user-list is NOT locked in $LOCK_FILE"
fi
