#!/usr/bin/env bash
# 1.2.1.4 - Ensure package manager repositories are configured (Manual)
# Verify repositories are configured correctly:
dnf repolist

# For the repositories in use, inspect configuration:
cat /etc/yum.repos.d/*.repo
