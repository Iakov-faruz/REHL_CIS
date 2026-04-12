#!/usr/bin/env bash
FAILED=0

echo "CHECK - /var/log/audit is mounted:"
RESULT=$(findmnt -kn /var/log/audit)
if [ -n "$RESULT" ]; then
    echo "CHECK - /var/log/audit is mounted: PASS"
else
    echo "CHECK - /var/log/audit is mounted: FAIL"
    FAILED=1
fi

if [ "${FAILED:-0}" -eq 0 ]; then
    echo "OVERALL - 1.1.2.7.1 Ensure separate partition exists for /var/log/audit: PASS"
else
    echo "OVERALL - 1.1.2.7.1 Ensure separate partition exists for /var/log/audit: FAIL"
fi
