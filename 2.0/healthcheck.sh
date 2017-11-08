#!/bin/sh
# This script must exit with:
# 0 on success
# 1 on error

# Abort if no healthcheck
[ "$NO_HEALTHCHECK" = "true" ] && exit 0

# Monitor login page
curl -f -H "User-Agent: Mozilla" http://localhost:9000/minio/login || exit 1
