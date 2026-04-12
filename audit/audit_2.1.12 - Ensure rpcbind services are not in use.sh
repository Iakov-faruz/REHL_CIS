#!/usr/bin/env bash
# CIS 2.1.12 - Ensure rpcbind services are not in use (Audit)
for SVC in rpcbind.socket rpcbind.service; do
    if ! rpm -q rpcbind &>/dev/null; then echo " - PASS: rpcbind not installed"; break; fi
    echo " - INFO: rpcbind is installed"
    ENABLED=$(systemctl is-enabled "$SVC" 2>/dev/null); ACTIVE=$(systemctl is-active "$SVC" 2>/dev/null)
    [ "$ENABLED" = "masked" ] && [ "$ACTIVE" != "active" ] && echo " - PASS: $SVC masked and inactive" || echo " - FAIL: $SVC enabled=$ENABLED active=$ACTIVE"
done
