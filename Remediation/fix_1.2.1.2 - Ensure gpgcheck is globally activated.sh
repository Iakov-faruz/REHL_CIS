#!/usr/bin/env bash
# Edit /etc/dnf/dnf.conf and set gpgcheck=1:
sed -i 's/^gpgcheck\s*=\s*.*/gpgcheck=1/' /etc/dnf/dnf.conf

# Edit any failing files in /etc/yum.repos.d/* and set all instances to 1:
find /etc/yum.repos.d/ -name "*.repo" -exec echo "Checking:" {} \; -exec sed -i 's/^gpgcheck\s*=\s*.*/gpgcheck=1/' {} \;
