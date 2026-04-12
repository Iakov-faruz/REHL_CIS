#!/usr/bin/env bash
# CIS 5.4.3.1 - Ensure nologin is not listed in /etc/shells
echo "=== CIS 5.4.3.1 - Ensure nologin is not listed in /etc/shells ==="
sed -ri '/\/nologin\b/d' /etc/shells 2>/dev/null
echo "[DONE] Remediation complete"
