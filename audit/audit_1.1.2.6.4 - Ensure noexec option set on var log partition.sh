#!/usr/bin/env bash
# IF: a separate partition exists for /var/log, verify that the noexec option is set.
FAILED=0

echo "CHECK - noexec set on /var/log:"
RESULT=$(findmnt -kn /var/log | grep -v noexec)
if [ -z "$RESULT" ]; then
    echo "CHECK - noexec set on /var/log: PASS"
else
    echo "CHECK - noexec set on /var/log: FAIL"
    FAILED=1
fi

if [ "${FAILED:-0}" -eq 0 ]; then
    echo "OVERALL - 1.1.2.6.4 Ensure noexec option set on /var/log partition: PASS"
else
    echo "OVERALL - 1.1.2.6.4 Ensure noexec option set on /var/log partition: FAIL"
fi
