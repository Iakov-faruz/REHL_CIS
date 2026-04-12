#!/usr/bin/env bash
# CIS 2.4.1.1 - Ensure cron daemon is enabled and active (Audit)

ENABLED=$(systemctl is-enabled crond.service 2>/dev/null)
ACTIVE=$(systemctl is-active crond.service 2>/dev/null)

if [ "$ENABLED" = "enabled" ] && [ "$ACTIVE" = "active" ]; then
    echo " - PASS: crond is enabled and active"
else
    echo " - FAIL: crond is enabled=$ENABLED, active=$ACTIVE"
fi
