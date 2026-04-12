#!/usr/bin/env bash
# CIS 1.8.4 - Ensure GDM screen locks when the user is idle
# Remediation script for RHEL 9 / CIS Benchmark

{
    l_key_file="/etc/dconf/db/local.d/00-screensaver"
    l_idmv="900" # Set max value for idle-delay in seconds (between 1 and 900)
    l_ldmv="5"   # Set max value for lock-delay in seconds (between 0 and 5)

    # Check if GDM is installed
    l_pkgoutput=""
    for l_pn in gdm gdm3; do
        rpm -q "$l_pn" > /dev/null 2>&1 && l_pkgoutput="installed"
        dpkg-query -W "$l_pn" > /dev/null 2>&1 && l_pkgoutput="installed"
    done

    if [ -n "$l_pkgoutput" ]; then
        # Check if already configured correctly
        l_kfile="$(grep -Psril '^\h*idle-delay\h*=\h*uint32\h+\d+\b' /etc/dconf/db/*/ 2>/dev/null)"
        if [ -n "$l_kfile" ]; then
            l_idv="$(awk -F 'uint32' '/idle-delay/{print $2}' "$l_kfile" | xargs)"
            l_ldv="$(awk -F 'uint32' '/lock-delay/{print $2}' "$l_kfile" | xargs)"
            if [ -n "$l_idv" ] && [ "$l_idv" -gt "0" ] && [ "$l_idv" -le "$l_idmv" ] && \
               [ -n "$l_ldv" ] && [ "$l_ldv" -ge "0" ] && [ "$l_ldv" -le "$l_ldmv" ]; then
                echo " - Screen lock idle settings are already configured correctly - no changes needed"
                echo " - idle-delay: $l_idv seconds, lock-delay: $l_ldv seconds"
            else
                echo " - Screen lock settings need updating - reconfiguring..."
                _create_screensaver_config
            fi
        else
            echo " - Screen lock settings not configured - configuring..."
            # Create profile and database directory
            if ! grep -Psq '^\h*system-db:local' /etc/dconf/profile/* 2>/dev/null; then
                echo -e '\nuser-db:user\nsystem-db:local' >> /etc/dconf/profile/user
            fi
            mkdir -p /etc/dconf/db/local.d

            {
                echo '# Specify the dconf path'
                echo '[org/gnome/desktop/session]'
                echo ''
                echo '# Number of seconds of inactivity before the screen goes blank'
                echo '# Set to 0 seconds if you want to deactivate the screensaver.'
                echo "idle-delay=uint32 $l_idmv"
                echo ''
                echo '# Specify the dconf path'
                echo '[org/gnome/desktop/screensaver]'
                echo ''
                echo '# Number of seconds after the screen is blank before locking the screen'
                echo "lock-delay=uint32 $l_ldmv"
            } > "$l_key_file"

            dconf update
            echo " - Screen lock settings configured: idle-delay=$l_idmv seconds, lock-delay=$l_ldmv seconds"
            echo " - NOTE: Users must log out and back in for changes to take effect"
        fi
    else
        echo " - GNOME Desktop Manager package is not installed - Recommendation is not applicable"
    fi
}

echo " - Done. GDM screen lock idle remediation complete."
