#!/usr/bin/env bash
# CIS 5.1.4 - Ensure sshd Ciphers are configured (Audit)
# Verify none of the "weak" ciphers are being used

echo "=== CIS 5.1.4 - Auditing sshd Ciphers ==="
RESULT=$(sshd -T 2>/dev/null | grep -Pi -- '^ciphers\h+\"?([^#\n\r]+,)?((3des|blowfish|cast128|aes(128|192|256))-cbc|arcfour(128|256)?|rijndael-cbc@lysator\.liu\.se|chacha20-poly1305@openssh\.com)\b')
if [ -n "$RESULT" ]; then
    echo " - FAIL: Weak ciphers found in sshd configuration:"
    echo "   $RESULT"
    echo " - Weak ciphers that should NOT be used:"
    echo "   3des-cbc, aes128-cbc, aes192-cbc, aes256-cbc"
    echo "   arcfour, arcfour128, arcfour256"
    echo "   blowfish-cbc, cast128-cbc"
    echo "   rijndael-cbc@lysator.liu.se"
    echo "   chacha20-poly1305@openssh.com (review CVE-2023-48795)"
else
    echo " - PASS: No weak ciphers found in sshd configuration"
fi
