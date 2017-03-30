from constants import *
from button import *
import time
import sensor

b = Button(BUTTON_PIN)

while True:
  time.sleep(0.2)
  if b.is_pressed():
    sensor.read_and_report(force_alert=True)
    time.sleep(1)
