#!/usr/bin/env bash
# IF: a separate partition exists for /var, verify that the nodev option is set.
FAILED=0

echo "CHECK - nodev set on /var:"
RESULT=$(findmnt -kn /var | grep -v nodev)
if [ -z "$RESULT" ]; then
    echo "CHECK - nodev set on /var: PASS"
else
    echo "CHECK - nodev set on /var: FAIL"
    FAILED=1
fi

if [ "${FAILED:-0}" -eq 0 ]; then
    echo "OVERALL - 1.1.2.4.2 Ensure nodev option set on /var partition: PASS"
else
    echo "OVERALL - 1.1.2.4.2 Ensure nodev option set on /var partition: FAIL"
fi
