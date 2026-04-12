#!/usr/bin/env bash
# CIS 3.2.2 - Ensure tipc kernel module is not available (Audit)
MODULE="tipc"
echo "=== Auditing $MODULE ==="
LOADED=$(lsmod | grep "^$MODULE ")
if [ -n "$LOADED" ]; then
    echo " - FAIL: $MODULE is currently loaded"
else
    echo " - PASS: $MODULE is not loaded"
fi

MODPROBE=$(modprobe -n -v "$MODULE" 2>/dev/null)
if echo "$MODPROBE" | grep -q "install /bin/true" || echo "$MODPROBE" | grep -q "install /bin/false"; then
    echo " - PASS: $MODULE is not loadable"
else
    if echo "$MODPROBE" | grep -q "FATAL: Module $MODULE not found"; then
        echo " - PASS: $MODULE not found (not loadable)"
    else
        echo " - FAIL: $MODULE is loadable. Output: $MODPROBE"
    fi
fi
