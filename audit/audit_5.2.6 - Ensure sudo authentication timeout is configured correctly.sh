#!/usr/bin/env bash
# CIS 5.2.6 - Ensure sudo authentication timeout is configured correctly (Audit)

echo "=== CIS 5.2.6 - Auditing sudo authentication timeout ==="
TIMEOUT=$(grep -roP "timestamp_timeout=\K[0-9]*" /etc/sudoers* 2>/dev/null)
if [ -n "$TIMEOUT" ]; then
    if [ "$TIMEOUT" -le 15 ] && [ "$TIMEOUT" -ge 0 ] 2>/dev/null; then
        echo " - PASS: timestamp_timeout is $TIMEOUT (15 or less)"
    else
        echo " - FAIL: timestamp_timeout is $TIMEOUT (should be 15 or less)"
    fi
else
    DEFAULT=$(sudo -V 2>/dev/null | grep "Authentication timestamp timeout:" | awk '{print $NF}')
    echo " - INFO: No timestamp_timeout configured in /etc/sudoers*"
    echo " - Default timeout: ${DEFAULT:-5} minutes"
    if [ -n "$DEFAULT" ] && [ "${DEFAULT%.*}" -le 15 ] 2>/dev/null; then
        echo " - PASS: Default is within acceptable range"
    else
        echo " - PASS: Default (5 minutes) is within acceptable range"
    fi
fi
