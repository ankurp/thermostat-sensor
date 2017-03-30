import sensor
import time
from constants import *

while True:
  sensor.read_and_report()
  time.sleep(REPORT_INTERVAL)
