#!/usr/bin/env bash
# CIS 5.1.6 - Ensure sshd MACs are configured (Audit)
# Verify none of the "weak" MACs are being used

echo "=== CIS 5.1.6 - Auditing sshd MACs ==="
RESULT=$(sshd -T 2>/dev/null | grep -Pi -- 'macs\h+([^#\n\r]+,)?(hmac-md5|hmac-md5-96|hmac-ripemd160|hmac-sha1-96|umac-64@openssh\.com|hmac-md5-etm@openssh\.com|hmac-md5-96-etm@openssh\.com|hmac-ripemd160-etm@openssh\.com|hmac-sha1-96-etm@openssh\.com|umac-64-etm@openssh\.com|umac-128-etm@openssh\.com)\b')
if [ -n "$RESULT" ]; then
    echo " - FAIL: Weak MACs found in sshd configuration:"
    echo "   $RESULT"
    echo " - Weak MACs that should NOT be used:"
    echo "   hmac-md5, hmac-md5-96, hmac-sha1-96"
    echo "   umac-64@openssh.com"
    echo "   hmac-md5-etm@openssh.com, hmac-md5-96-etm@openssh.com"
    echo "   hmac-sha1-96-etm@openssh.com"
    echo "   umac-64-etm@openssh.com, umac-128-etm@openssh.com"
else
    echo " - PASS: No weak MACs found in sshd configuration"
fi
