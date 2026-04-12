#!/usr/bin/env bash
# CIS 2.1.18 - Ensure web server services are not in use (httpd, nginx)
# Remediation script for RHEL 9 / CIS Benchmark

SVC1="httpd.socket"
SVC2="httpd.service"
SVC3="nginx.service"

# Stop all web server services
systemctl stop "$SVC1" "$SVC2" "$SVC3" 2>/dev/null || true

# Handle httpd
if rpm -q httpd &>/dev/null; then
    DEPS=$(rpm -q --whatrequires httpd 2>/dev/null | grep -v "^no package" || true)
    if [ -n "$DEPS" ]; then
        echo " - Package httpd is required by: $DEPS"
        echo " - Masking httpd services (leaving package installed)"
        systemctl mask "$SVC1" "$SVC2" 2>/dev/null || true
        echo " - $SVC1 and $SVC2 are masked"
    else
        echo " - Package httpd is installed - removing..."
        dnf remove -y httpd
        echo " - httpd removed"
    fi
else
    echo " - Package httpd is not installed"
fi

# Handle nginx
if rpm -q nginx &>/dev/null; then
    DEPS=$(rpm -q --whatrequires nginx 2>/dev/null | grep -v "^no package" || true)
    if [ -n "$DEPS" ]; then
        echo " - Package nginx is required by: $DEPS"
        echo " - Masking nginx service (leaving package installed)"
        systemctl mask "$SVC3" 2>/dev/null || true
        echo " - $SVC3 is masked"
    else
        echo " - Package nginx is installed - removing..."
        dnf remove -y nginx
        echo " - nginx removed"
    fi
else
    echo " - Package nginx is not installed"
fi

echo " - Done. Web server services remediation complete."
echo " - NOTE: Other web server packages may exist. These should also be checked."
