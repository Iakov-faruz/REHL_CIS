#!/usr/bin/env bash
# CIS 5.4.1.4 - Ensure strong password hashing algorithm is configured
echo "=== CIS 5.4.1.4 - Ensure strong password hashing algorithm is configured ==="
if grep -q 'ENCRYPT_METHOD' /etc/login.defs; then sed -ri 's/^ENCRYPT_METHOD.*/ENCRYPT_METHOD SHA512/' /etc/login.defs; else echo "ENCRYPT_METHOD SHA512" >> /etc/login.defs; fi
echo "[DONE] Remediation complete"
