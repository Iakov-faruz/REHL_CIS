#!/usr/bin/env bash
# CIS 7.2.1 - Ensure accounts in passwd use shadowed passwords
echo "=== CIS 7.2.1 - Convert to Shadowed Passwords ==="
pwconv; grpconv
echo "[DONE] Converted to shadowed passwords"
