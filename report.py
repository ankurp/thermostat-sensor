import requests
import json
import Adafruit_DHT as dht
import time
import datetime

mac = open('/sys/class/net/wlan0/address').readline()[0:17]
headers = { 'content-type': 'application/json' }

while True:
  h, t = dht.read_retry(dht.DHT22, 4)
  data = {
    "reading": {
      "humidity": h,
      "temperature": t,
      "sensor_id": mac
    }
  }
  try:
    response = requests.post('http://thermostat.encoredevlabs.com/readings', data=json.dumps(data), headers=headers)
  except requests.exceptions.RequestException as e:
    print("Error: {}".format(e))
  time.sleep(15)
