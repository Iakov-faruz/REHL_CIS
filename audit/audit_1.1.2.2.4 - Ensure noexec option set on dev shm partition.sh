#!/usr/bin/env bash
# IF: a separate partition exists for /dev/shm, verify that the noexec option is set.
FAILED=0

echo "CHECK - noexec set on /dev/shm:"
RESULT=$(findmnt -kn /dev/shm | grep -v 'noexec')
if [ -z "$RESULT" ]; then
    echo "CHECK - noexec set on /dev/shm: PASS"
else
    echo "CHECK - noexec set on /dev/shm: FAIL"
    FAILED=1
fi

if [ "${FAILED:-0}" -eq 0 ]; then
    echo "OVERALL - 1.1.2.2.4 Ensure noexec option set on /dev/shm partition: PASS"
else
    echo "OVERALL - 1.1.2.2.4 Ensure noexec option set on /dev/shm partition: FAIL"
fi
