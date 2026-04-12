#!/usr/bin/env bash
# IF: a separate partition exists for /home, verify that the nodev option is set.
FAILED=0

echo "CHECK - nodev set on /home:"
RESULT=$(findmnt -kn /home | grep -v nodev)
if [ -z "$RESULT" ]; then
    echo "CHECK - nodev set on /home: PASS"
else
    echo "CHECK - nodev set on /home: FAIL"
    FAILED=1
fi

if [ "${FAILED:-0}" -eq 0 ]; then
    echo "OVERALL - 1.1.2.3.2 Ensure nodev option set on /home partition: PASS"
else
    echo "OVERALL - 1.1.2.3.2 Ensure nodev option set on /home partition: FAIL"
fi
