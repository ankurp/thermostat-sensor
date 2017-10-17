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
1. Once you have the OS on the MicroSD Card you should mount it add create an empty called `ssh` in the `/boot` volume of the MicroSD card image to remote login via ssh into the Raspberry Pi
1. Also you can auto connect your Raspberry Pi to your Wifi by creating a `wpa_supplicant.conf` file in the `/boot` volume of the MicroSD card image. Enter the credentials to your Wifi in this file by copy pasting the contents below and replacing it with your Wifi name and password.
```
ctrl_interface=DIR=/var/run/wpa_supplicant GROUP=netdev
update_config=1
country=US

network={
	ssid="WIFINAME"
	psk="PASSWORD"
	key_mgmt=WPA-PSK
}
```
1. Once OS is installed and remote login and Wifi configured, insert the MicroSD Card in the Raspberry Pi.
1. Connect the Temperature/Humidity Sensor to the Raspberry Pi by Connecting the `Positive (+) end` via the jumper cable to the `3V Pin`, Connecting the `Negative (-) end` via the jumper cable to the `Ground (GND) Pin` and Connecting the `Data end` via the jumper cable to the `GPIO Pin 4` on the Raspberry Pi.
1. Connect the Push Button to the Raspberry Pi by connecting any one of the jumper cables to `GPIO Pin 25` and the other to `Ground (GND)`
1. Power up the Raspberry Pi and login via SSH or connect it to a monitor/keyboard/mouse and open the terminal and follow the software installation instructions below

![Raspberry Pi 3 with Temperature Sensor and Button](https://raw.githubusercontent.com/ankurp/thermostat-sensor/master/assets/screenshot.jpeg)
![Showing Pin Connection](https://raw.githubusercontent.com/ankurp/thermostat-sensor/master/assets/pin.jpg)

## Software Install Instructions

SSH into the Raspberry Pi after powering it. Make sure you are in the same Wifi network to SSH. The default hostname will be `raspberrypi` so you can login via `ssh pi@raspberrypi.local`. The default password is `raspberry`

1. First change the password using `passwd`
1. Then install docker using this command `curl -sSL https://get.docker.com | sh`
1. Then make the pi user be able to executa commands as sudo user inside of the docker container via this command `sudo usermod -aG docker pi`
1. Reboot raspberry pi using `sudo shutdown -r now`
1. Then pull the docker container containing our code `docker pull encoreptl/thermostat-sensor:latest`
1. Add the following to the `/etc/rc.local` before the `exit 0` line
```
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

You can configure by setting the following environment variables in the docker run command to your liking:

* `SERVER_DOMAIN` - Setting this will post the reading to this domain and it can container port number as well
* `REPORT_INTERVAL` - Frequency of how often you want to send temperature readings in seconds
* `BUTTON_PIN` - Pin number where you have the button installed
* `TEMP_SENSOR_PIN` - Pin number where you have the temperature sensor installed

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
