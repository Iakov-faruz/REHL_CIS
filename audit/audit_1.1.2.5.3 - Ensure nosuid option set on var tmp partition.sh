#!/usr/bin/env bash
# IF: a separate partition exists for /var/tmp, verify that the nosuid option is set.
FAILED=0

echo "CHECK - nosuid set on /var/tmp:"
RESULT=$(findmnt -kn /var/tmp | grep -v nosuid)
if [ -z "$RESULT" ]; then
    echo "CHECK - nosuid set on /var/tmp: PASS"
else
    echo "CHECK - nosuid set on /var/tmp: FAIL"
    FAILED=1
fi

if [ "${FAILED:-0}" -eq 0 ]; then
    echo "OVERALL - 1.1.2.5.3 Ensure nosuid option set on /var/tmp partition: PASS"
else
    echo "OVERALL - 1.1.2.5.3 Ensure nosuid option set on /var/tmp partition: FAIL"
fi
