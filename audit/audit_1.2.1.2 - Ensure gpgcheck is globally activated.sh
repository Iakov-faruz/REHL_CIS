#!/usr/bin/env bash
FAILED=0

echo "CHECK 1 - gpgcheck globally enabled in /etc/dnf/dnf.conf:"
RESULT=$(grep -Pi -- '^\h*gpgcheck\h*=\h*(1|true|yes)\b' /etc/dnf/dnf.conf)
if [ -n "$RESULT" ]; then
    echo "CHECK 1 - gpgcheck globally enabled: PASS"
else
    echo "CHECK 1 - gpgcheck globally enabled: FAIL"
    FAILED=1
fi

echo "CHECK 2 - No repos have gpgcheck=0 in /etc/yum.repos.d/:"
RESULT=$(grep -Pris -- '^\h*gpgcheck\h*=\h*(0|[2-9]|[1-9][0-9]+|false|no)\b' /etc/yum.repos.d/)
if [ -z "$RESULT" ]; then
    echo "CHECK 2 - No repos have gpgcheck=0: PASS"
else
    echo "CHECK 2 - No repos have gpgcheck=0: FAIL"
    echo "$RESULT"
    FAILED=1
fi

if [ "${FAILED:-0}" -eq 0 ]; then
    echo "OVERALL - 1.2.1.2 Ensure gpgcheck is globally activated: PASS"
else
    echo "OVERALL - 1.2.1.2 Ensure gpgcheck is globally activated: FAIL"
fi
