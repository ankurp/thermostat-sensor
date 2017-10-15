# thermostat-sensor

This repository only contains code and instructions on how to setup the Raspberry Pi device to report temperature/humidity data along with manual alerts to the server. The server code where data is received and saved, notifications are sent, and the entire system configured via the admin portal, can be found on [thermostat repo](https://github.com/ankurp/thermostat).

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

1. `curl -sSL https://get.docker.com | sh`
1. `sudo usermod -aG docker pi`
1. Add the following to the `/etc/rc.local` before the `exit 0` line
```
docker pull encoreptl/thermostat-sensor:latest
docker run \
	--privileged \
	-e PYTHONUNBUFFERED=1 \
	-e SERVER_DOMAIN=thermostat.encoredevlabs.com \
	-e BUTTON_PIN=25 \
	-e TEMP_SENSOR_PIN=4 \
	-e REPORT_INTERVAL=60 \
	-v /sys:/sys \
	-d \
	encoreptl/thermostat-sensor
```

## Configure where to send Temperature Data, Reading Frequency and GPIO PIN numbers

To send temperature data to your own server, you need to update the [constants.py](https://github.com/ankurp/thermostat-sensor/blob/master/constants.py#L1), `SERVER_DOMAIN` variable to point to domain with port number of your server.

You can also change the frequency of how often you want to send temperature readings in seconds by changing the `REPORT_INTERVAL` variable in `constants.py` (Setting it to 60 means a temperature reading will be sent every minute).

You can also change the pin numbers where you have the temperature sensor and button connected to in the `constants.py` file, if you connected them to different pins on Raspberry Pi than mentioned above.

## Register Device to Website

You will need to get the MAC address of the Wifi (`wlan0`) network interface so that you can [register the device on the server via the Admin Portal](https://github.com/ankurp/thermostat/blob/master/README.md#addingregistering-device-on-the-website) otherwise the server will not accept readings from this sensor.

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
