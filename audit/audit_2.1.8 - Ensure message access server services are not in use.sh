#!/usr/bin/env bash
# CIS 2.1.8 - Ensure message access server services are not in use (Audit)
for PKG in dovecot cyrus-imapd; do
    if ! rpm -q "$PKG" &>/dev/null; then
        echo " - PASS: $PKG is not installed"
    else
        echo " - INFO: $PKG is installed"
        for SVC in dovecot.socket dovecot.service cyrus-imapd.service; do
            ENABLED=$(systemctl is-enabled "$SVC" 2>/dev/null); ACTIVE=$(systemctl is-active "$SVC" 2>/dev/null)
            [ "$ENABLED" = "masked" ] && [ "$ACTIVE" != "active" ] && echo " - PASS: $SVC is masked and inactive" || echo " - FAIL: $SVC enabled=$ENABLED active=$ACTIVE"
        done
    fi
done
