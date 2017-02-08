import requests
import json
import Adafruit_DHT as dht
import time
import datetime
from button import *

b = Button(25)
mac = open('/sys/class/net/wlan0/address').readline()[0:17]
headers = { 'content-type': 'application/json' }

while True:
  if b.is_pressed():
    print("Sending alert...")
    h, t = dht.read_retry(dht.DHT22, 4)
    data = {
      "reading": {
        "humidity": h,
        "temperature": t,
        "sensor_id": mac,
        "force_alert": True
      }
    }
    try:
      response = requests.post('http://thermostat.encoredevlabs.com/readings', data=json.dumps(data), headers=headers)
    except requests.exceptions.RequestException as e:
      print("Error: {}".format(e))
    print("Alert Sent")
    time.sleep(1)
