#!/usr/bin/env bash
setenforce 1

SELINUX_CONFIG="/etc/selinux/config"
if grep -Eq '^\s*SELINUX=' "$SELINUX_CONFIG"; then
    sed -i 's/^\s*SELINUX=.*/SELINUX=enforcing/' "$SELINUX_CONFIG"
else
    echo "SELINUX=enforcing" >> "$SELINUX_CONFIG"
fi
