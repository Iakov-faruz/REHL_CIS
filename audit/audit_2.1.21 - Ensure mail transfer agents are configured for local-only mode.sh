#!/usr/bin/env bash
# CIS 2.1.21 - Ensure mail transfer agents are configured for local-only mode (Audit)

if ! rpm -q postfix &>/dev/null; then
    echo " - INFO: postfix is not installed - check if another MTA is in use"
    exit 0
fi

CURRENT=$(postconf -n inet_interfaces 2>/dev/null)
echo " - Current postfix inet_interfaces: $CURRENT"

if echo "$CURRENT" | grep -q "loopback-only"; then
    echo " - PASS: postfix is configured for local-only mode (loopback-only)"
else
    echo " - FAIL: postfix inet_interfaces is not set to loopback-only"
    echo " - Run: postconf -n inet_interfaces"
    postconf -n inet_interfaces 2>/dev/null
fi
