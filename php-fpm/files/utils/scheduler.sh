#!/usr/bin/env bash

# exit immediately if a command exits with a non-zero status.
set -euo pipefail

# Enable crontab
sed -i 's/# \(.*artisan schedule.*\)/\1/' /etc/crontabs/www-data

crond -f -l 0 -d 8 -c /etc/crontabs