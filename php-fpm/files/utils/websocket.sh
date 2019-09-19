#!/usr/bin/env bash

# exit immediately if a command exits with a non-zero status.
set -euo pipefail

php artisan websockets:serve