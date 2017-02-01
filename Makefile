all: install

install: adafruitlib
	sed 's|'boot.sh'|'$(pwd)/boot.sh'|' rc.local | sudo tee /etc/rc.local
	sed -i 's|'./report.py'|'$(pwd)/report.py'|' boot.sh
	sudo reboot

deps:
	sudo apt-get update
	sudo apt-get install build-essential python-dev

adafruitlib: clean deps
	git clone https://github.com/adafruit/Adafruit_Python_DHT.git
	cd Adafruit_Python_DHT && sudo python setup.py install

clean:
	sudo rm -rf Adafruit_Python_DHT
