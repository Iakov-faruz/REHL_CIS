#!/usr/bin/env bash
# CIS 1.7.5 - Ensure access to /etc/issue is configured
# Remediation script for RHEL 9 / CIS Benchmark

ISSUE_FILE="/etc/issue"

if [ -e "$ISSUE_FILE" ]; then
    # Check current permissions and ownership
    CURRENT_PERMS=$(stat -Lc '%#a' "$ISSUE_FILE" 2>/dev/null)
    CURRENT_UID=$(stat -Lc '%u' "$ISSUE_FILE" 2>/dev/null)
    CURRENT_GID=$(stat -Lc '%g' "$ISSUE_FILE" 2>/dev/null)

    NEEDS_FIX=false
    # Check if permissions are more permissive than 644 (or not exactly 644)
    # Valid values: 0644, 0640, 0600 etc. must be 644 or more restrictive
    if ! echo "$CURRENT_PERMS" | grep -Pq '^0[0-6][0-4][0-4]$'; then
        NEEDS_FIX=true
    fi
    [ "$CURRENT_UID" != "0" ] && NEEDS_FIX=true
    [ "$CURRENT_GID" != "0" ] && NEEDS_FIX=true

    if [ "$NEEDS_FIX" = true ]; then
        echo " - /etc/issue has incorrect permissions/ownership - fixing..."
        chown root:root "$(readlink -e $ISSUE_FILE)"
        chmod u-x,go-wx "$(readlink -e $ISSUE_FILE)"
        echo " - Fixed permissions on $ISSUE_FILE"
        echo " - New permissions: $(stat -Lc 'Access: (%#a/%A) Uid: ( %u/ %U) Gid: ( %g/ %G)' $ISSUE_FILE)"
    else
        echo " - /etc/issue already has correct permissions - no changes needed"
        echo " - Current: $(stat -Lc 'Access: (%#a/%A) Uid: ( %u/ %U) Gid: ( %g/ %G)' $ISSUE_FILE)"
    fi
else
    echo " - /etc/issue does not exist - creating with default secure content"
    echo "Authorized uses only. All activity may be monitored and reported." > "$ISSUE_FILE"
    chown root:root "$ISSUE_FILE"
    chmod 0644 "$ISSUE_FILE"
fi

echo " - Done. /etc/issue access remediation complete."
