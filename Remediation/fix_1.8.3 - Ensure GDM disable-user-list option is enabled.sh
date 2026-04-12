#!/usr/bin/env bash
# CIS 1.8.3 - Ensure GDM disable-user-list option is enabled
# Remediation script for RHEL 9 / CIS Benchmark

{
    l_gdmprofile="gdm"

    # Check if GDM is installed
    if command -v rpm > /dev/null 2>&1; then
        l_pq="rpm -q"
    elif command -v dpkg-query > /dev/null 2>&1; then
        l_pq="dpkg-query -W"
    fi

    l_pkgoutput=""
    for l_pn in gdm gdm3; do
        $l_pq "$l_pn" > /dev/null 2>&1 && l_pkgoutput="installed"
    done

    if [ -n "$l_pkgoutput" ]; then
        # Check if already configured
        if grep -Pril '^h*disable-user-list\h*=\h*true\b' /etc/dconf/db 2>/dev/null | grep -q .; then
            echo " - disable-user-list is already set to true - no changes needed"
        else
            echo " - Configuring disable-user-list option..."

            if [ ! -f "/etc/dconf/profile/$l_gdmprofile" ]; then
                echo " - Creating profile \"$l_gdmprofile\""
                echo -e "user-db:user\nsystem-db:$l_gdmprofile\nfiledb:/usr/share/$l_gdmprofile/greeter-dconf-defaults" > /etc/dconf/profile/$l_gdmprofile
            fi

            if [ ! -d "/etc/dconf/db/$l_gdmprofile.d/" ]; then
                echo " - Creating dconf database directory \"/etc/dconf/db/$l_gdmprofile.d/\""
                mkdir /etc/dconf/db/$l_gdmprofile.d/
            fi

            if ! grep -Piq '^\h*disable-user-list\h*=\h*true\b' /etc/dconf/db/$l_gdmprofile.d/* 2>/dev/null; then
                echo " - creating gdm keyfile for machine-wide settings"
                if ! grep -Piq -- '^\h*\[org\/gnome\/login-screen\]' /etc/dconf/db/$l_gdmprofile.d/* 2>/dev/null; then
                    echo -e "\n[org/gnome/login-screen]\n# Do not show the user list\ndisable-user-list=true" >> /etc/dconf/db/$l_gdmprofile.d/00-loginscreen
                else
                    sed -ri '/^\s*\[org\/gnome\/login-screen\]/ a\# Do not show the user list\ndisable-user-list=true' \
                        $(grep -Pil -- '^\h*\[org\/gnome\/login-screen\]' /etc/dconf/db/$l_gdmprofile.d/*)
                fi
            fi

            dconf update
            echo " - disable-user-list option configured successfully"
            echo " - NOTE: Users will need to log out and log in again before changes take effect"
        fi
    else
        echo " - GNOME Desktop Manager isn't installed - Recommendation is Not Applicable"
    fi
}

echo " - Done. GDM disable-user-list remediation complete."
