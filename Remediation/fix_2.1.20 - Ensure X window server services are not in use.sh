#!/usr/bin/env bash
# CIS 2.1.20 - Ensure X window server services are not in use (Level 2 - Server)
# Remediation script for RHEL 9 / CIS Benchmark

PKG="xorg-x11-server-common"

# Check if a Graphical Desktop Manager is required
echo " - NOTE: This is a Level 2 - Server recommendation."
echo " - NOTE: If a Graphical Desktop Manager (GDM) is required, do NOT run this script."
echo " - NOTE: Some Java packages have dependencies on X Windows xorg-x11-fonts."
echo ""

# Check if package is installed
if rpm -q "$PKG" &>/dev/null; then
    DEPS=$(rpm -q --whatrequires "$PKG" 2>/dev/null | grep -v "^no package" || true)
    if [ -n "$DEPS" ]; then
        echo " - Package $PKG is required by: $DEPS"
        echo " - Cannot remove package - it has dependents"
        echo " - Consider using headless Java packages to remove this dependency"
    else
        echo " - Package $PKG is installed with no required dependents - removing..."
        dnf remove -y "$PKG"
        echo " - $PKG removed"
    fi
else
    echo " - Package $PKG is not installed - no changes needed"
fi

echo " - Done. X Window server service remediation complete."
