import requests
import json
import Adafruit_DHT as dht
from constants import *

mac = open('/sys/class/net/wlan0/address').readline()[0:17]
headers = { 'content-type': 'application/json' }

def read_and_report(force_alert=False):
  h, t = dht.read_retry(dht.DHT22, TEMP_SENSOR_PIN)
  data = {
    "reading": {
      "humidity": h,
      "temperature": t,
      "sensor_id": mac
    }
  }

  if force_alert:  
    data['reading']['force_alert'] = True

  print("Sending reading: {}".format(data))
  try:
    response = requests.post(
      "http://{DOMAIN}/readings".format(DOMAIN=SERVER_DOMAIN),
      data=json.dumps(data), headers=headers)
    print("Reading Sent")
  except requests.exceptions.RequestException as e:
    print("Error sending reading: {}".format(e))

