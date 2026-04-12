#!/usr/bin/env bash
# CIS 5.1.8 - Ensure sshd Banner is configured (Audit)
# Verify Banner is set to a path

echo "=== CIS 5.1.8 - Auditing sshd Banner ==="
BANNER=$(sshd -T 2>/dev/null | grep -Pi -- '^banner\h+\/\H+')
if [ -n "$BANNER" ]; then
    echo " - PASS: Banner is configured:"
    echo "   $BANNER"
    BANNER_FILE=$(sshd -T 2>/dev/null | awk '$1 == "banner" {print $2}')
    if [ -e "$BANNER_FILE" ]; then
        echo " - Banner file contents:"
        cat "$BANNER_FILE"
        # Check for OS info disclosure
        DISCLOSURE=$(grep -Psi -- "(\\\\v|\\\\r|\\\\m|\\\\s|\b$(grep '^ID=' /etc/os-release 2>/dev/null | cut -d= -f2 | sed -e 's/"//g')\b)" "$BANNER_FILE" 2>/dev/null)
        if [ -n "$DISCLOSURE" ]; then
            echo " - WARNING: Banner file may contain OS information disclosure"
        fi
    else
        echo " - WARNING: Banner file $BANNER_FILE does not exist"
    fi
else
    echo " - FAIL: Banner is not configured in sshd"
fi
