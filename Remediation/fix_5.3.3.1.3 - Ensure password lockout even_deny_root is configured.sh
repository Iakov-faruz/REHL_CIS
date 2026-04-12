#!/usr/bin/env bash
# CIS 5.3.3.1.3 - Ensure password lockout even_deny_root is configured
echo "=== CIS 5.3.3.1.3 - Ensure password lockout even_deny_root is configured ==="
if ! grep -Piq '^\s*even_deny_root' /etc/security/faillock.conf; then echo "even_deny_root" >> /etc/security/faillock.conf; fi
echo "[DONE] Remediation complete"
