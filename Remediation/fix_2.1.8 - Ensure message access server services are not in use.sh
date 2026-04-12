#!/usr/bin/env bash
# CIS 2.1.8 - Ensure message access server services are not in use (dovecot/cyrus-imapd)
# Remediation script for RHEL 9 / CIS Benchmark

for PKG in dovecot cyrus-imapd; do
    if rpm -q "$PKG" &>/dev/null; then
        DEPS=$(rpm -q --whatrequires "$PKG" 2>/dev/null | grep -v "^no package" || true)
        if [ -n "$DEPS" ]; then
            echo " - Package $PKG is required by: $DEPS"
            echo " - Stopping and masking services for $PKG (leaving package installed)"
        else
            echo " - Package $PKG is installed - removing..."
        fi
    else
        echo " - Package $PKG is not installed - no changes needed"
    fi
done

# Stop all related services
systemctl stop dovecot.socket dovecot.service cyrus-imapd.service 2>/dev/null || true

# Handle dovecot
if rpm -q dovecot &>/dev/null; then
    DEPS=$(rpm -q --whatrequires dovecot 2>/dev/null | grep -v "^no package" || true)
    if [ -n "$DEPS" ]; then
        systemctl mask dovecot.socket dovecot.service 2>/dev/null || true
        echo " - dovecot services stopped and masked"
    else
        dnf remove -y dovecot
        echo " - dovecot removed"
    fi
fi

# Handle cyrus-imapd
if rpm -q cyrus-imapd &>/dev/null; then
    DEPS=$(rpm -q --whatrequires cyrus-imapd 2>/dev/null | grep -v "^no package" || true)
    if [ -n "$DEPS" ]; then
        systemctl mask cyrus-imapd.service 2>/dev/null || true
        echo " - cyrus-imapd service stopped and masked"
    else
        dnf remove -y cyrus-imapd
        echo " - cyrus-imapd removed"
    fi
fi

echo " - Done. Message access server service remediation complete."
