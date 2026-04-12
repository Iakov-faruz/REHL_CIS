#!/usr/bin/env bash
# CIS 2.1.18 - Ensure web server services are not in use (Audit)
for PKG_SVC in "httpd:httpd.service" "httpd:httpd.socket" "nginx:nginx.service"; do
    PKG="${PKG_SVC%%:*}"; SVC="${PKG_SVC##*:}"
    if ! rpm -q "$PKG" &>/dev/null; then echo " - PASS: $PKG not installed"; continue; fi
    echo " - INFO: $PKG is installed"
    ENABLED=$(systemctl is-enabled "$SVC" 2>/dev/null); ACTIVE=$(systemctl is-active "$SVC" 2>/dev/null)
    [ "$ENABLED" = "masked" ] && [ "$ACTIVE" != "active" ] && echo " - PASS: $SVC masked and inactive" || echo " - FAIL: $SVC enabled=$ENABLED active=$ACTIVE"
done
