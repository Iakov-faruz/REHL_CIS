#!/usr/bin/env bash
# CIS 1.8.8 - Ensure GDM autorun-never is enabled (Audit)

if ! rpm -q gdm &>/dev/null; then
    echo " - N/A: gdm is not installed - skipping"
    exit 0
fi

GDM_CONF="/etc/dconf/db/local.d/00-media-automount"

if grep -Pqs '^\h*autorun-never\h*=\h*true\b' "$GDM_CONF" 2>/dev/null; then
    echo " - PASS: autorun-never = true is set in $GDM_CONF"
else
    echo " - FAIL: autorun-never = true is NOT set in $GDM_CONF"
fi
