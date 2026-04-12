#!/usr/bin/env bash
# 1.2.1.3 - Ensure repo_gpgcheck is globally activated (Manual)
# Global configuration:
grep ^repo_gpgcheck /etc/dnf/dnf.conf
# Verify that repo_gpgcheck is set to 1.

# Per repository - example: list repos (excluding fedoraproject.org) with repo_gpgcheck=0:
REPO_URL="fedoraproject.org"
for repo in $(grep -l "repo_gpgcheck=0" /etc/yum.repos.d/* ); do
 if ! grep "${REPO_URL}" "${repo}" &> /dev/null; then
  echo "${repo}"
 fi
done
