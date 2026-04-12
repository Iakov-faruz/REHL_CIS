#!/usr/bin/env bash
# CIS 1.5.4 - Ensure core dump storage is disabled
# Remediation script for RHEL 9 / CIS Benchmark

CONF_DIR="/etc/systemd/coredump.conf.d"
CONF_FILE="$CONF_DIR/60-coredump.conf"

# Create directory if it doesn't exist
if [ ! -d "$CONF_DIR" ]; then
    echo " - Creating directory $CONF_DIR"
    mkdir -p "$CONF_DIR"
fi

# Check if already configured correctly
if grep -Psq '^\h*Storage\h*=\h*none\b' "$CONF_FILE" 2>/dev/null; then
    echo " - Storage is already set to none in $CONF_FILE - no changes needed"
else
    echo " - Configuring Storage=none in $CONF_FILE"

    # Check if [Coredump] section exists in file
    if grep -Psq '^\h*\[Coredump\]' "$CONF_FILE" 2>/dev/null; then
        # Section exists - check if Storage entry exists
        if grep -Pq '^\h*Storage\h*=' "$CONF_FILE" 2>/dev/null; then
            # Update existing entry
            sed -i 's/^\s*Storage\s*=.*/Storage=none/' "$CONF_FILE"
            echo " - Updated existing Storage entry to none"
        else
            # Add after [Coredump] section header
            printf '%s\n' "Storage=none" >> "$CONF_FILE"
            echo " - Added Storage=none to $CONF_FILE"
        fi
    else
        # Create or append with [Coredump] section
        printf '%s\n' "[Coredump]" "Storage=none" >> "$CONF_FILE"
        echo " - Created [Coredump] section with Storage=none in $CONF_FILE"
    fi
fi

echo " - Done. Core dump storage remediation complete."
