#!/usr/bin/env bash
# CIS 2.1.16 - Ensure tftp server services are not in use (Audit)
for SVC in tftp.socket tftp.service; do
    if ! rpm -q tftp-server &>/dev/null; then echo " - PASS: tftp-server not installed"; break; fi
    echo " - INFO: tftp-server is installed"
    ENABLED=$(systemctl is-enabled "$SVC" 2>/dev/null); ACTIVE=$(systemctl is-active "$SVC" 2>/dev/null)
    [ "$ENABLED" = "masked" ] && [ "$ACTIVE" != "active" ] && echo " - PASS: $SVC masked and inactive" || echo " - FAIL: $SVC enabled=$ENABLED active=$ACTIVE"
done
