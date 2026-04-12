#!/usr/bin/env bash
# CIS 5.1.5 - Ensure sshd KexAlgorithms is configured (Audit)
# Verify none of the "weak" Key Exchange algorithms are being used

echo "=== CIS 5.1.5 - Auditing sshd KexAlgorithms ==="
RESULT=$(sshd -T 2>/dev/null | grep -Pi -- 'kexalgorithms\h+([^#\n\r]+,)?(diffie-hellman-group1-sha1|diffie-hellman-group14-sha1|diffie-hellman-group-exchange-sha1)\b')
if [ -n "$RESULT" ]; then
    echo " - FAIL: Weak Key Exchange algorithms found:"
    echo "   $RESULT"
    echo " - Weak KexAlgorithms that should NOT be used:"
    echo "   diffie-hellman-group1-sha1"
    echo "   diffie-hellman-group14-sha1"
    echo "   diffie-hellman-group-exchange-sha1"
else
    echo " - PASS: No weak Key Exchange algorithms found"
fi
