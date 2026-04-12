#!/usr/bin/env bash
# CIS 2.1.13 - Ensure rsync services are not in use (Audit)
for SVC in rsyncd.socket rsyncd.service; do
    if ! rpm -q rsync-daemon &>/dev/null; then echo " - PASS: rsync-daemon not installed"; break; fi
    echo " - INFO: rsync-daemon is installed"
    ENABLED=$(systemctl is-enabled "$SVC" 2>/dev/null); ACTIVE=$(systemctl is-active "$SVC" 2>/dev/null)
    [ "$ENABLED" = "masked" ] && [ "$ACTIVE" != "active" ] && echo " - PASS: $SVC masked and inactive" || echo " - FAIL: $SVC enabled=$ENABLED active=$ACTIVE"
done
