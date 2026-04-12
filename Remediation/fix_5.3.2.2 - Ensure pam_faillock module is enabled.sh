#!/usr/bin/env bash
# CIS 5.3.2.2 - Ensure pam_faillock module is enabled (Remediation)
echo "=== CIS 5.3.2.2 - Enabling pam_faillock ==="

# Check if profile templates include conditional faillock lines
PROFILE="$(head -1 /etc/authselect/authselect.conf 2>/dev/null)"
if grep -Pq -- '^custom\/' <<< "$PROFILE"; then
    PROFILE_PATH="/etc/authselect/$PROFILE"
else
    PROFILE_PATH="/usr/share/authselect/default/$PROFILE"
fi

if grep -Pq 'include if "with-faillock"' "$PROFILE_PATH"/{password,system}-auth 2>/dev/null; then
    authselect enable-feature with-faillock
    echo " - Enabled authselect feature: with-faillock"
else
    authselect apply-changes 2>/dev/null
    echo " - Applied authselect changes"
fi
