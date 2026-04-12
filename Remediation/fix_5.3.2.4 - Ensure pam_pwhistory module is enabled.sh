#!/usr/bin/env bash
# CIS 5.3.2.4 - Ensure pam_pwhistory module is enabled (Remediation)
echo "=== CIS 5.3.2.4 - Enabling pam_pwhistory ==="

PROFILE="$(head -1 /etc/authselect/authselect.conf 2>/dev/null)"
if grep -Pq -- '^custom\/' <<< "$PROFILE"; then
    PROFILE_PATH="/etc/authselect/$PROFILE"
else
    PROFILE_PATH="/usr/share/authselect/default/$PROFILE"
fi

if grep -Pq 'include if "with-pwhistory"' "$PROFILE_PATH"/{password,system}-auth 2>/dev/null; then
    authselect enable-feature with-pwhistory
    echo " - Enabled authselect feature: with-pwhistory"
else
    authselect apply-changes 2>/dev/null
    echo " - Applied authselect changes"
fi
