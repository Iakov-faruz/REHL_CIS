#!/usr/bin/env bash
# CIS 1.8.4 - Ensure GDM screen locks when the user is idle (Audit)

if ! rpm -q gdm &>/dev/null; then
    echo " - N/A: gdm is not installed - skipping"
    exit 0
fi

GDM_CONF="/etc/dconf/db/local.d/00-screensaver"

echo "=== Checking GDM screen lock idle settings ==="

IDLE_DELAY=$(grep -Ps '^\h*idle-delay\h*=\h*' "$GDM_CONF" 2>/dev/null | awk -F= '{print $2}' | xargs)
LOCK_DELAY=$(grep -Ps '^\h*lock-delay\h*=\h*' "$GDM_CONF" 2>/dev/null | awk -F= '{print $2}' | xargs)

if [ -n "$IDLE_DELAY" ] && [ "$IDLE_DELAY" -gt 0 ] && [ "$IDLE_DELAY" -le 900 ]; then
    echo " - PASS: idle-delay = $IDLE_DELAY (≤900 seconds)"
elif [ -n "$IDLE_DELAY" ]; then
    echo " - FAIL: idle-delay = $IDLE_DELAY - should be > 0 and ≤ 900"
else
    echo " - FAIL: idle-delay is not configured in $GDM_CONF"
fi

if [ -n "$LOCK_DELAY" ] && [ "$LOCK_DELAY" -le 5 ]; then
    echo " - PASS: lock-delay = $LOCK_DELAY (≤5 seconds)"
elif [ -n "$LOCK_DELAY" ]; then
    echo " - FAIL: lock-delay = $LOCK_DELAY - should be ≤ 5"
else
    echo " - FAIL: lock-delay is not configured in $GDM_CONF"
fi
