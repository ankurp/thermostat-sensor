# thermostat-sensor

This repository only contains code and instructions on how to setup the Raspberry Pi device to report temperature/humidity data along with manual alerts to the server. The server code where data is received and notifications are sent out can be found on [thermostat repo](https://github.com/ankurp/thermostat)

![Raspberry Pi 3](https://raw.githubusercontent.com/ankurp/thermostat-sensor/master/assets/splash.png)

## Requirements

You will need the following items
1. [Raspberry Pi with Wifi](http://www.microcenter.com/product/475267/Zero_Wireless_Development_Board)
2. [Temperature/Humidity Sensor](https://www.amazon.com/gp/product/B018JO5BRK)
3. [Push Buttons](https://www.amazon.com/gp/product/B0170B75EU)
4. 4GB or bigger Micro SD Card.
5. [5V Micro USB Power Adapter](https://www.amazon.com/dp/B00MARDJZ4). You can use any Android Phone/Tablet Charger found in home as well or power it using a USB to MicroUSB cable as well.
6. Case (Optional to package everything together)

## Raspberry Pi/Hardware Setup Instructions

1. Install [Raspbian Image](https://www.raspberrypi.org/downloads/raspbian/) (Operating System to run on Raspberry Pi) from official Raspberry Pi website onto the Micro SD Card. You can find the installation instructions on how to install the Raspbian OS onto the Micro SD Card [here](https://www.raspberrypi.org/documentation/installation/installing-images/README.md)
2. Once OS is installed insert the MicroSD Card in the Raspberry Pi
3. Connect the Temperature/Humidity Sensor to the Raspberry Pi by Connecting the `Positive (+) end` via the jumper cable to the `3V Pin`, Connecting the `Negative (-) end` via the jumper cable to the `Ground (GND) Pin` and Connecting the `Data end` via the jumper cable to the `GPIO Pin 4` on the Raspberry Pi.
4. Connect the Push Button to the Raspberry Pi by connecting any one of the jumper cables to `GPIO Pin 25` and the other to `Ground (GND)`
5. Power up the Raspberry Pi and login via SSH or connect it to a monitor/keyboard/mouse and open the terminal and follow the software installation instructions below

![Raspberry Pi 3 with Temperature Sensor and Button](https://raw.githubusercontent.com/ankurp/thermostat-sensor/master/assets/screenshot.jpeg)
![Showing Pin Connection](https://raw.githubusercontent.com/ankurp/thermostat-sensor/master/assets/pin.jpg)

## Software Install Instructions

1. `git clone https://github.com/ankurp/thermostat-sensor.git`
2. `cd thermostat-sensor`
3. `make`

## Configure where to send Temperature Data 

To send temperature data to your own server, you need to update the [report.py](https://github.com/ankurp/thermostat-sensor/blob/master/report.py) and [alert.py](https://github.com/ankurp/thermostat-sensor/blob/master/alert.py) files with your server's domain name.

## Hostname
Change hostname of Raspberry Pi if needed to help differentiate from one another.

## Remote Access

Setup remote access via SSH using `ngrok` over the internet by downloading the binary from here: https://bin.equinox.io/c/4VmDzA7iaHb/ngrok-stable-linux-arm.zip

Then unzip it and setup the ngrok yml config file as such:
```yaml
authtoken: <Get Auth Token after registering on ngrok.com>
json_resolver_url: ""
dns_resolver_ips: []
tunnels:
  ssh:
    proto: tcp
    addr: 22
```

To run ngrok in background just run the following line `/path/to/ngrok start ssh --config=/home/pi/.ngrok2/ngrok.yml > /dev/null &`. You can add this to the rc.local file to start `ngrok` on reboot.

## Scheduled Reboot
Setup crontab to reboot every few hours incase there are issues in reporting or being able to connect remotely using ssh via ngrok.

1. `sudo -i`
2. `crontab -e`
3. Add the following line `0 * * * * /sbin/shutdown -r now`
