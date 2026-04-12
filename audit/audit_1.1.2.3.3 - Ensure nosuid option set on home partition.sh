#!/usr/bin/env bash
# IF: a separate partition exists for /home, verify that the nosuid option is set.
FAILED=0

echo "CHECK - nosuid set on /home:"
RESULT=$(findmnt -kn /home | grep -v nosuid)
if [ -z "$RESULT" ]; then
    echo "CHECK - nosuid set on /home: PASS"
else
    echo "CHECK - nosuid set on /home: FAIL"
    FAILED=1
fi

if [ "${FAILED:-0}" -eq 0 ]; then
    echo "OVERALL - 1.1.2.3.3 Ensure nosuid option set on /home partition: PASS"
else
    echo "OVERALL - 1.1.2.3.3 Ensure nosuid option set on /home partition: FAIL"
fi
