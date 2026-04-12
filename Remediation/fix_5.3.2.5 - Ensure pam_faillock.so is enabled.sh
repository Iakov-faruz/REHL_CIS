#!/usr/bin/env bash
# CIS 5.3.2.5 - Ensure pam_faillock.so is enabled
echo "=== CIS 5.3.2.5 - Ensure pam_faillock.so is enabled ==="
authselect enable-feature with-faillock; authselect apply-changes
echo "[DONE] Remediation complete"
