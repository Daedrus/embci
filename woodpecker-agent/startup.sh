#!/bin/bash

# Script adapted from
# https://docs.docker.com/config/containers/multi-service_container/

# Add symlink to power supply /dev entry
ln -s /dev/${DEV_POWER_SUPPLY} /dev/ttyPowerSupply

# Start the Logic2 Automation API
xvfb-run /opt/Logic2 --automation --no-sandbox --disable-gpu --headless > /tmp/saleae.log 2>&1 &

# Start the Woodpecker Agent
/bin/woodpecker-agent &

# Wait for any process to exit
wait -n

# Exit with status of process that exited first
exit $?
