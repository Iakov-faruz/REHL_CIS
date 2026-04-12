#!/usr/bin/env bash
# CIS 1.5.3 - Ensure core dump backtraces are disabled
# Remediation script for RHEL 9 / CIS Benchmark

CONF_DIR="/etc/systemd/coredump.conf.d"
CONF_FILE="$CONF_DIR/60-coredump.conf"

# Create directory if it doesn't exist
if [ ! -d "$CONF_DIR" ]; then
    echo " - Creating directory $CONF_DIR"
    mkdir -p "$CONF_DIR"
fi

# Check if already configured correctly
if grep -Psq '^\h*ProcessSizeMax\h*=\h*0\b' "$CONF_FILE" 2>/dev/null; then
    echo " - ProcessSizeMax is already set to 0 in $CONF_FILE - no changes needed"
else
    echo " - Configuring ProcessSizeMax=0 in $CONF_FILE"

    # Check if [Coredump] section exists in file
    if grep -Psq '^\h*\[Coredump\]' "$CONF_FILE" 2>/dev/null; then
        # Section exists - check if ProcessSizeMax entry exists
        if grep -Pq '^\h*ProcessSizeMax\h*=' "$CONF_FILE" 2>/dev/null; then
            # Update existing entry
            sed -i 's/^\s*ProcessSizeMax\s*=.*/ProcessSizeMax=0/' "$CONF_FILE"
            echo " - Updated existing ProcessSizeMax entry to 0"
        else
            # Add after [Coredump] section
            printf '%s\n' "ProcessSizeMax=0" >> "$CONF_FILE"
            echo " - Added ProcessSizeMax=0 to $CONF_FILE"
        fi
    else
        # Create or append with [Coredump] section
        printf '%s\n' "[Coredump]" "ProcessSizeMax=0" >> "$CONF_FILE"
        echo " - Created [Coredump] section with ProcessSizeMax=0 in $CONF_FILE"
    fi
fi

echo " - Done. Core dump backtrace remediation complete."
