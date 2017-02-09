#!/bin/sh

sleep 10 && /usr/bin/python /home/pi/thermostat-sensor/report.py
sleep 10 && /usr/bin/python /home/pi/thermostat-sensor/alert.py
