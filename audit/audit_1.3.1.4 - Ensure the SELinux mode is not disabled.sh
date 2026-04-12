#!/usr/bin/env bash
FAILED=0

echo "CHECK 1 - SELinux current mode is not disabled:"
RESULT=$(getenforce)
if [ "$RESULT" = "Enforcing" ] || [ "$RESULT" = "Permissive" ]; then
    echo "CHECK 1 - getenforce: PASS ($RESULT)"
else
    echo "CHECK 1 - getenforce: FAIL ($RESULT)"
    FAILED=1
fi

echo "CHECK 2 - SELINUX config is enforcing or permissive:"
RESULT=$(grep -Ei '^\s*SELINUX=(enforcing|permissive)' /etc/selinux/config)
if [ -n "$RESULT" ]; then
    echo "CHECK 2 - /etc/selinux/config: PASS ($RESULT)"
else
    echo "CHECK 2 - /etc/selinux/config: FAIL"
    FAILED=1
fi

if [ "${FAILED:-0}" -eq 0 ]; then
    echo "OVERALL - 1.3.1.4 Ensure the SELinux mode is not disabled: PASS"
else
    echo "OVERALL - 1.3.1.4 Ensure the SELinux mode is not disabled: FAIL"
fi
