#!/usr/bin/env bash
FAILED=0

echo "CHECK - /home is mounted:"
RESULT=$(findmnt -kn /home)
if [ -n "$RESULT" ]; then
    echo "CHECK - /home is mounted: PASS"
else
    echo "CHECK - /home is mounted: FAIL"
    FAILED=1
fi

if [ "${FAILED:-0}" -eq 0 ]; then
    echo "OVERALL - 1.1.2.3.1 Ensure separate partition exists for /home: PASS"
else
    echo "OVERALL - 1.1.2.3.1 Ensure separate partition exists for /home: FAIL"
fi
