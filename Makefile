all: install

install: adafruitlib
	sudo pwd=$(pwd) sed 's|'boot.sh'|'$pwd/boot.sh'|' rc.local > /etc/rc.local
	sudo reboot

deps:
	sudo apt-get update
	sudo apt-get install build-essential python-dev

adafruitlib: deps
	git clone https://github.com/adafruit/Adafruit_Python_DHT.git
	cd Adafruit_Python_DHT
	sudo python setup.py install
