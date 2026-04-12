#!/usr/bin/env bash
# 1.2.1.3 - Ensure repo_gpgcheck is globally activated (Manual)
# Global configuration - Edit /etc/dnf/dnf.conf and set repo_gpgcheck=1 in the [main] section.
# Example:
#   [main]
#   repo_gpgcheck=1
#
# Per repository configuration:
# First check that the particular repository supports GPG checking on the repodata.
# Edit any failing files in /etc/yum.repos.d/* and set all instances starting with
# repo_gpgcheck to 1.
