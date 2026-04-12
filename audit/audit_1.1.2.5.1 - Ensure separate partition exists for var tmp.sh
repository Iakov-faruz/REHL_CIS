#!/usr/bin/env bash
FAILED=0

echo "CHECK - /var/tmp is mounted:"
RESULT=$(findmnt -kn /var/tmp)
if [ -n "$RESULT" ]; then
    echo "CHECK - /var/tmp is mounted: PASS"
else
    echo "CHECK - /var/tmp is mounted: FAIL"
    FAILED=1
fi

if [ "${FAILED:-0}" -eq 0 ]; then
    echo "OVERALL - 1.1.2.5.1 Ensure separate partition exists for /var/tmp: PASS"
else
    echo "OVERALL - 1.1.2.5.1 Ensure separate partition exists for /var/tmp: FAIL"
fi
