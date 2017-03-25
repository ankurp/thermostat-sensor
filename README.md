# thermostat-sensor

![Raspberry Pi 3](https://raw.githubusercontent.com/ankurp/thermostat-sensor/master/assets/splash.png)

![Raspberry Pi 3 with Temperature Sensor and Button](https://raw.githubusercontent.com/ankurp/thermostat-sensor/master/assets/screenshot.jpeg)

# Install Instructions

1. `git clone https://github.com/ankurp/thermostat-sensor.git`
2. `cd thermostat-sensor`
3. `make`

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
