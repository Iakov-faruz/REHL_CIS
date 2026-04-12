#!/usr/bin/env bash
# CIS 2.1.11 - Ensure print server services are not in use (Audit)
for SVC in cups.socket cups.service; do
    if ! rpm -q cups &>/dev/null; then echo " - PASS: cups not installed"; break; fi
    echo " - INFO: cups is installed"
    ENABLED=$(systemctl is-enabled "$SVC" 2>/dev/null); ACTIVE=$(systemctl is-active "$SVC" 2>/dev/null)
    [ "$ENABLED" = "masked" ] && [ "$ACTIVE" != "active" ] && echo " - PASS: $SVC masked and inactive" || echo " - FAIL: $SVC enabled=$ENABLED active=$ACTIVE"
done
