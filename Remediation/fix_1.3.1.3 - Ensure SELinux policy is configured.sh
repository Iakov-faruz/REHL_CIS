#!/usr/bin/env bash
# Edit /etc/selinux/config and set SELINUXTYPE=targeted
SELINUX_CONFIG="/etc/selinux/config"

if grep -Eq '^\s*SELINUXTYPE=' "$SELINUX_CONFIG"; then
    sed -i 's/^\s*SELINUXTYPE=.*/SELINUXTYPE=targeted/' "$SELINUX_CONFIG"
else
    echo "SELINUXTYPE=targeted" >> "$SELINUX_CONFIG"
fi
