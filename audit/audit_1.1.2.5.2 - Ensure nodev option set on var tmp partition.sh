#!/usr/bin/env bash
# IF: a separate partition exists for /var/tmp, verify that the nodev option is set.
FAILED=0

echo "CHECK - nodev set on /var/tmp:"
RESULT=$(findmnt -kn /var/tmp | grep -v nodev)
if [ -z "$RESULT" ]; then
    echo "CHECK - nodev set on /var/tmp: PASS"
else
    echo "CHECK - nodev set on /var/tmp: FAIL"
    FAILED=1
fi

if [ "${FAILED:-0}" -eq 0 ]; then
    echo "OVERALL - 1.1.2.5.2 Ensure nodev option set on /var/tmp partition: PASS"
else
    echo "OVERALL - 1.1.2.5.2 Ensure nodev option set on /var/tmp partition: FAIL"
fi
