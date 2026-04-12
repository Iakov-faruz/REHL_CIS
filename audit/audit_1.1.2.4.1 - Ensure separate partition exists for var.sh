#!/usr/bin/env bash
FAILED=0

echo "CHECK - /var is mounted:"
RESULT=$(findmnt -kn /var)
if [ -n "$RESULT" ]; then
    echo "CHECK - /var is mounted: PASS"
else
    echo "CHECK - /var is mounted: FAIL"
    FAILED=1
fi

if [ "${FAILED:-0}" -eq 0 ]; then
    echo "OVERALL - 1.1.2.4.1 Ensure separate partition exists for /var: PASS"
else
    echo "OVERALL - 1.1.2.4.1 Ensure separate partition exists for /var: FAIL"
fi
