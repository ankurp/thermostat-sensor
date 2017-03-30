#!/bin/sh

/home/pi/ngrok start ssh --config=/home/pi/.ngrok2/ngrok.yml > /dev/null &
sleep 10 && /usr/bin/python /home/pi/thermostat-sensor/reading.py &
/usr/bin/python /home/pi/thermostat-sensor/alert.py &
