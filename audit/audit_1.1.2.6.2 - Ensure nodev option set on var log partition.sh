#!/usr/bin/env bash
# IF: a separate partition exists for /var/log, verify that the nodev option is set.
FAILED=0

echo "CHECK - nodev set on /var/log:"
RESULT=$(findmnt -kn /var/log | grep -v nodev)
if [ -z "$RESULT" ]; then
    echo "CHECK - nodev set on /var/log: PASS"
else
    echo "CHECK - nodev set on /var/log: FAIL"
    FAILED=1
fi

if [ "${FAILED:-0}" -eq 0 ]; then
    echo "OVERALL - 1.1.2.6.2 Ensure nodev option set on /var/log partition: PASS"
else
    echo "OVERALL - 1.1.2.6.2 Ensure nodev option set on /var/log partition: FAIL"
fi
