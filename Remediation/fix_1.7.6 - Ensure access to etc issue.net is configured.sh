#!/usr/bin/env bash
# CIS 1.7.6 - Ensure access to /etc/issue.net is configured
# Remediation script for RHEL 9 / CIS Benchmark

ISSUE_NET_FILE="/etc/issue.net"

if [ -e "$ISSUE_NET_FILE" ]; then
    # Check current permissions and ownership
    CURRENT_PERMS=$(stat -Lc '%#a' "$ISSUE_NET_FILE" 2>/dev/null)
    CURRENT_UID=$(stat -Lc '%u' "$ISSUE_NET_FILE" 2>/dev/null)
    CURRENT_GID=$(stat -Lc '%g' "$ISSUE_NET_FILE" 2>/dev/null)

    NEEDS_FIX=false
    [ "$CURRENT_UID" != "0" ] && NEEDS_FIX=true
    [ "$CURRENT_GID" != "0" ] && NEEDS_FIX=true
    # Check permissions - should be 644 or more restrictive
    # Convert octal to check - mode bits for group/other write (0022) should NOT be set
    if [ $((8#${CURRENT_PERMS#0} & 8#022)) -ne 0 ] || [ $((8#${CURRENT_PERMS#0} & 8#111)) -ne 0 ]; then
        NEEDS_FIX=true
    fi

    if [ "$NEEDS_FIX" = true ]; then
        echo " - /etc/issue.net has incorrect permissions/ownership - fixing..."
        chown root:root "$(readlink -e $ISSUE_NET_FILE)"
        chmod u-x,go-wx "$(readlink -e $ISSUE_NET_FILE)"
        echo " - Fixed permissions on $ISSUE_NET_FILE"
        echo " - New permissions: $(stat -Lc 'Access: (%#a/%A) Uid: ( %u/ %U) Gid: ( %g/ %G)' $ISSUE_NET_FILE)"
    else
        echo " - /etc/issue.net already has correct permissions - no changes needed"
        echo " - Current: $(stat -Lc 'Access: (%#a/%A) Uid: ( %u/ %U) Gid: ( %g/ %G)' $ISSUE_NET_FILE)"
    fi
else
    echo " - /etc/issue.net does not exist - creating with default secure content"
    echo "Authorized uses only. All activity may be monitored and reported." > "$ISSUE_NET_FILE"
    chown root:root "$ISSUE_NET_FILE"
    chmod 0644 "$ISSUE_NET_FILE"
fi

echo " - Done. /etc/issue.net access remediation complete."
