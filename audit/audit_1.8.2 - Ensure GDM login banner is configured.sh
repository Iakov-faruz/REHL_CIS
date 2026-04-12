#!/usr/bin/env bash
# CIS 1.8.2 - Ensure GDM login banner is configured (Audit)

if ! rpm -q gdm &>/dev/null; then
    echo " - N/A: gdm is not installed - skipping"
    exit 0
fi

BANNER_FILE="/etc/dconf/db/gdm.d/01-banner-message"
LOCK_FILE="/etc/dconf/db/gdm.d/locks/01-banner-message"

echo "=== Checking GDM login banner ==="
if grep -Pqs '^\h*banner-message-enable\h*=\h*true\b' "$BANNER_FILE" 2>/dev/null; then
    echo " - PASS: banner-message-enable = true is set in $BANNER_FILE"
else
    echo " - FAIL: banner-message-enable = true is NOT set in $BANNER_FILE"
fi

if grep -Pqs '^\h*banner-message-text\h*=' "$BANNER_FILE" 2>/dev/null; then
    echo " - PASS: banner-message-text is configured"
    grep 'banner-message-text' "$BANNER_FILE"
else
    echo " - FAIL: banner-message-text is NOT configured in $BANNER_FILE"
fi

if grep -Pqs '^\h*banner-message-enable\b' "$LOCK_FILE" 2>/dev/null && \
   grep -Pqs '^\h*banner-message-text\b' "$LOCK_FILE" 2>/dev/null; then
    echo " - PASS: banner settings are locked in $LOCK_FILE"
else
    echo " - FAIL: banner settings are NOT properly locked in $LOCK_FILE"
fi
