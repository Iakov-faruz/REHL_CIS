#!/usr/bin/env bash
# CIS 5.3.1.3 - Ensure latest version of libpwquality is installed (Audit)

echo "=== CIS 5.3.1.3 - Auditing libpwquality version ==="
LIB_VER=$(rpm -q libpwquality 2>/dev/null)
if [ $? -eq 0 ]; then
    echo " - Installed: $LIB_VER"
    echo " - Required: libpwquality-1.4.4-8 or greater"
    echo " - Verify that the installed version meets the minimum requirement"
else
    echo " - FAIL: libpwquality package is not installed"
fi
