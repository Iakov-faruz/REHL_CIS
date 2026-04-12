#!/usr/bin/env bash
FAILED=0

echo "CHECK - /var/log is mounted:"
RESULT=$(findmnt -kn /var/log)
if [ -n "$RESULT" ]; then
    echo "CHECK - /var/log is mounted: PASS"
else
    echo "CHECK - /var/log is mounted: FAIL"
    FAILED=1
fi

if [ "${FAILED:-0}" -eq 0 ]; then
    echo "OVERALL - 1.1.2.6.1 Ensure separate partition exists for /var/log: PASS"
else
    echo "OVERALL - 1.1.2.6.1 Ensure separate partition exists for /var/log: FAIL"
fi
