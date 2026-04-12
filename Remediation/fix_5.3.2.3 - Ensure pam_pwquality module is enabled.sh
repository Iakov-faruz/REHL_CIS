#!/usr/bin/env bash
# CIS 5.3.2.3 - Ensure pam_pwquality module is enabled (Remediation)
echo "=== CIS 5.3.2.3 - Enabling pam_pwquality ==="

PROFILE="$(head -1 /etc/authselect/authselect.conf 2>/dev/null)"
if grep -Pq -- '^custom\/' <<< "$PROFILE"; then
    PROFILE_PATH="/etc/authselect/$PROFILE"
else
    PROFILE_PATH="/usr/share/authselect/default/$PROFILE"
fi

if grep -Pq 'include if "with-pwquality"' "$PROFILE_PATH"/{password,system}-auth 2>/dev/null; then
    authselect enable-feature with-pwquality
    echo " - Enabled authselect feature: with-pwquality"
else
    authselect apply-changes 2>/dev/null
    echo " - Applied authselect changes"
fi
