#!/usr/bin/env bash
# CIS 2.1.3 - Ensure dhcp server services are not in use
# Remediation script for RHEL 9 / CIS Benchmark

PKG="dhcp-server"
SVC1="dhcpd.service"
SVC2="dhcpd6.service"

# Check if package is installed
if rpm -q "$PKG" &>/dev/null; then
    DEPS=$(rpm -q --whatrequires "$PKG" 2>/dev/null | grep -v "^no package" || true)
    if [ -n "$DEPS" ]; then
        echo " - Package $PKG is required by: $DEPS"
        echo " - Stopping and masking services (leaving package installed)"
        systemctl stop "$SVC1" "$SVC2" 2>/dev/null || true
        systemctl mask "$SVC1" "$SVC2" 2>/dev/null || true
        echo " - $SVC1 and $SVC2 are stopped and masked"
    else
        echo " - Package $PKG is installed - removing..."
        systemctl stop "$SVC1" "$SVC2" 2>/dev/null || true
        dnf remove -y "$PKG"
        echo " - $PKG removed"
    fi
else
    echo " - Package $PKG is not installed - no changes needed"
fi

echo " - Done. DHCP server service remediation complete."
