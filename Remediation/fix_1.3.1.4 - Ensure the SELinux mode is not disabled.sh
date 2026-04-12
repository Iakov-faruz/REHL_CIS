#!/usr/bin/env bash
# Set SELinux running mode to Enforcing (or Permissive if site policy requires):
setenforce 1

# Update /etc/selinux/config to persist the setting:
SELINUX_CONFIG="/etc/selinux/config"
if grep -Eq '^\s*SELINUX=' "$SELINUX_CONFIG"; then
    sed -i 's/^\s*SELINUX=.*/SELINUX=enforcing/' "$SELINUX_CONFIG"
else
    echo "SELINUX=enforcing" >> "$SELINUX_CONFIG"
fi
