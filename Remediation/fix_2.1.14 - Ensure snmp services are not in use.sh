#!/usr/bin/env bash
# CIS 2.1.14 - Ensure snmp services are not in use
# Remediation script for RHEL 9 / CIS Benchmark

PKG="net-snmp"
SVC="snmpd.service"

# Check if package is installed
if rpm -q "$PKG" &>/dev/null; then
    DEPS=$(rpm -q --whatrequires "$PKG" 2>/dev/null | grep -v "^no package" || true)
    if [ -n "$DEPS" ]; then
        echo " - Package $PKG is required by: $DEPS"
        echo " - Stopping and masking service (leaving package installed)"
        systemctl stop "$SVC" 2>/dev/null || true
        systemctl mask "$SVC" 2>/dev/null || true
        echo " - $SVC is stopped and masked"
    else
        echo " - Package $PKG is installed - removing..."
        systemctl stop "$SVC" 2>/dev/null || true
        dnf remove -y "$PKG"
        echo " - $PKG removed"
    fi
else
    echo " - Package $PKG is not installed - no changes needed"
fi

echo " - Done. SNMP service remediation complete."
echo " - NOTE: If SNMP is required, configure for SNMPv3 only with authentication and encryption."
