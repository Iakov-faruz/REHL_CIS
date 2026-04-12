#!/usr/bin/env bash
# CIS 1.7.4 - Ensure access to /etc/motd is configured
# Remediation script for RHEL 9 / CIS Benchmark

MOTD_FILE="/etc/motd"

if [ -e "$MOTD_FILE" ]; then
    # Check current permissions
    CURRENT_PERMS=$(stat -Lc '%#a' "$MOTD_FILE" 2>/dev/null)
    CURRENT_UID=$(stat -Lc '%u' "$MOTD_FILE" 2>/dev/null)
    CURRENT_GID=$(stat -Lc '%g' "$MOTD_FILE" 2>/dev/null)

    NEEDS_FIX=false
    # Check if permissions are more permissive than 644
    if [ "$CURRENT_PERMS" != "0644" ] && [ "$CURRENT_PERMS" != "0640" ] && [ "$CURRENT_PERMS" != "0600" ] && [ "$CURRENT_PERMS" != "0400" ]; then
        NEEDS_FIX=true
    fi
    [ "$CURRENT_UID" != "0" ] && NEEDS_FIX=true
    [ "$CURRENT_GID" != "0" ] && NEEDS_FIX=true

    if [ "$NEEDS_FIX" = true ]; then
        echo " - /etc/motd has incorrect permissions/ownership - fixing..."
        chown root:root "$(readlink -e $MOTD_FILE)"
        chmod u-x,go-wx "$(readlink -e $MOTD_FILE)"
        echo " - Fixed permissions on $MOTD_FILE"
        echo " - New permissions: $(stat -Lc 'Access: (%#a/%A) Uid: ( %u/ %U) Gid: ( %g/ %G)' $MOTD_FILE)"
    else
        echo " - /etc/motd already has correct permissions - no changes needed"
        echo " - Current: $(stat -Lc 'Access: (%#a/%A) Uid: ( %u/ %U) Gid: ( %g/ %G)' $MOTD_FILE)"
    fi
else
    echo " - /etc/motd does not exist - this is acceptable if MOTD is not required"
fi

echo " - Done. /etc/motd access remediation complete."
