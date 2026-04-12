#!/usr/bin/env bash
# CIS 2.1.19 - Ensure xinetd services are not in use (Audit)
PKG="xinetd"; SVC="xinetd.service"
if ! rpm -q "$PKG" &>/dev/null; then echo " - PASS: $PKG not installed"; exit 0; fi
echo " - INFO: $PKG is installed"
ENABLED=$(systemctl is-enabled "$SVC" 2>/dev/null); ACTIVE=$(systemctl is-active "$SVC" 2>/dev/null)
[ "$ENABLED" = "masked" ] && [ "$ACTIVE" != "active" ] && echo " - PASS: $SVC is masked and inactive" || echo " - FAIL: $SVC enabled=$ENABLED active=$ACTIVE"
