#!/usr/bin/env bash
# IF: a separate partition exists for /tmp, verify that the nosuid option is set.
FAILED=0

echo "CHECK - nosuid set on /tmp:"
RESULT=$(findmnt -kn /tmp | grep -v nosuid)
if [ -z "$RESULT" ]; then
    echo "CHECK - nosuid set on /tmp: PASS"
else
    echo "CHECK - nosuid set on /tmp: FAIL"
    FAILED=1
fi

if [ "${FAILED:-0}" -eq 0 ]; then
    echo "OVERALL - 1.1.2.1.3 Ensure nosuid option set on /tmp partition: PASS"
else
    echo "OVERALL - 1.1.2.1.3 Ensure nosuid option set on /tmp partition: FAIL"
fi
