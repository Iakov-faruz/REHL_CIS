#!/usr/bin/env bash
# 1.3.1.6 - Ensure no unconfined services exist (Manual)
echo "Checking for unconfined services:"
ps -eZ | grep unconfined_service_t
# Nothing should be returned.
