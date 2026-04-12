#!/usr/bin/env bash
# IF: a separate partition exists for /var/tmp, verify that the noexec option is set.
FAILED=0

echo "CHECK - noexec set on /var/tmp:"
RESULT=$(findmnt -kn /var/tmp | grep -v noexec)
if [ -z "$RESULT" ]; then
    echo "CHECK - noexec set on /var/tmp: PASS"
else
    echo "CHECK - noexec set on /var/tmp: FAIL"
    FAILED=1
fi

if [ "${FAILED:-0}" -eq 0 ]; then
    echo "OVERALL - 1.1.2.5.4 Ensure noexec option set on /var/tmp partition: PASS"
else
    echo "OVERALL - 1.1.2.5.4 Ensure noexec option set on /var/tmp partition: FAIL"
fi
