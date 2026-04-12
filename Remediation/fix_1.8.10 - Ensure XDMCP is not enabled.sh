#!/usr/bin/env bash
# CIS 1.8.10 - Ensure XDMCP is not enabled
# Remediation script for RHEL 9 / CIS Benchmark

GDM_CONF="/etc/gdm/custom.conf"

# Check if XDMCP is enabled
if grep -Eis '^\s*Enable\s*=\s*true' "$GDM_CONF" 2>/dev/null; then
    echo " - XDMCP is enabled in $GDM_CONF - removing the Enable=true line..."
    sed -i '/^\s*Enable\s*=\s*true/Id' "$GDM_CONF"
    echo " - Enable=true line removed from $GDM_CONF"
    echo " - Verifying: $(grep -Eis '^\s*Enable\s*=\s*true' $GDM_CONF 2>/dev/null || echo 'No Enable=true found - PASS')"
else
    echo " - XDMCP is not enabled in $GDM_CONF - no changes needed"
fi

echo " - Done. XDMCP disable remediation complete."
