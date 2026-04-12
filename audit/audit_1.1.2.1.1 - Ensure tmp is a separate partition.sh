#!/usr/bin/env bash
# IF: an entry for /tmp exists in /etc/fstab it will take precedence over
# entries in systemd default unit file.
FAILED=0

echo "CHECK 1 - /tmp is mounted:"
RESULT=$(findmnt -kn /tmp)
if [ -n "$RESULT" ]; then
    echo "CHECK 1 - /tmp is mounted: PASS"
else
    echo "CHECK 1 - /tmp is mounted: FAIL"
    FAILED=1
fi

echo "CHECK 2 - tmp.mount is enabled (not masked or disabled):"
RESULT=$(systemctl is-enabled tmp.mount)
if [ "$RESULT" != "masked" ] && [ "$RESULT" != "disabled" ]; then
    echo "CHECK 2 - tmp.mount is enabled (not masked or disabled): PASS"
else
    echo "CHECK 2 - tmp.mount is enabled (not masked or disabled): FAIL"
    FAILED=1
fi

if [ "${FAILED:-0}" -eq 0 ]; then
    echo "OVERALL - 1.1.2.1.1 Ensure /tmp is a separate partition: PASS"
else
    echo "OVERALL - 1.1.2.1.1 Ensure /tmp is a separate partition: FAIL"
fi
