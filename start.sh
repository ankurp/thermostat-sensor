#!/bin/bash

# Enable i2c - needed for the Display-O-Tron HAT
modprobe i2c-dev

# Start resin-wifi-connect
export DBUS_SYSTEM_BUS_ADDRESS=unix:path=/host/run/dbus/system_bus_socket
sleep 1
node resin-wifi-connect/src/app.js --clear=false

# At this point the WiFi connection has been configured and the device has
# internet - unless the configured WiFi connection is no longer available.

# Start the main application
/usr/local/bin/foreman start
