#!/usr/bin/env bash
# Audit helper function - check if a service package is removed or service is masked
# Usage: check_service_not_in_use <package> <service>
check_service_not_in_use() {
    local PKG="$1"
    local SVC="$2"

    if ! rpm -q "$PKG" &>/dev/null; then
        echo " - PASS: $PKG is not installed"
        return 0
    fi

    echo " - INFO: $PKG is installed"
    local ENABLED
    ENABLED=$(systemctl is-enabled "$SVC" 2>/dev/null)
    local ACTIVE
    ACTIVE=$(systemctl is-active "$SVC" 2>/dev/null)

    if [ "$ENABLED" = "masked" ] && [ "$ACTIVE" != "active" ]; then
        echo " - PASS: $SVC is masked and not active"
    else
        echo " - FAIL: $SVC is enabled=$ENABLED active=$ACTIVE (should be masked/inactive)"
    fi
}

echo "=== CIS 2.1.1 - Ensure autofs services are not in use ==="
check_service_not_in_use "autofs" "autofs.service"
