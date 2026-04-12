#!/usr/bin/env bash
# CIS 1.8.6 - Ensure GDM automatic mounting of removable media is disabled (Audit)

if ! rpm -q gdm &>/dev/null; then
    echo " - N/A: gdm is not installed - skipping"
    exit 0
fi

GDM_CONF="/etc/dconf/db/local.d/00-media-automount"

echo "=== Checking GDM automount settings ==="
if grep -Pqs '^\h*automount\h*=\h*false\b' "$GDM_CONF" 2>/dev/null; then
    echo " - PASS: automount = false is set in $GDM_CONF"
else
    echo " - FAIL: automount = false is NOT set in $GDM_CONF"
fi

if grep -Pqs '^\h*automount-open\h*=\h*false\b' "$GDM_CONF" 2>/dev/null; then
    echo " - PASS: automount-open = false is set in $GDM_CONF"
else
    echo " - FAIL: automount-open = false is NOT set in $GDM_CONF"
fi
