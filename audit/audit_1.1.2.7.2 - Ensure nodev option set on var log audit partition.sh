#!/usr/bin/env bash
# IF: a separate partition exists for /var/log/audit, verify that the nodev option is set.
FAILED=0

echo "CHECK - nodev set on /var/log/audit:"
RESULT=$(findmnt -kn /var/log/audit | grep -v nodev)
if [ -z "$RESULT" ]; then
    echo "CHECK - nodev set on /var/log/audit: PASS"
else
    echo "CHECK - nodev set on /var/log/audit: FAIL"
    FAILED=1
fi

if [ "${FAILED:-0}" -eq 0 ]; then
    echo "OVERALL - 1.1.2.7.2 Ensure nodev option set on /var/log/audit partition: PASS"
else
    echo "OVERALL - 1.1.2.7.2 Ensure nodev option set on /var/log/audit partition: FAIL"
fi
