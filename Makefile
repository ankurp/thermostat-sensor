all: install

install: clean deps adafruitlib squid
	sed 's|'boot.sh'|'$(pwd)/boot.sh'|' rc.local | sudo tee /etc/rc.local
	sed -i 's|'./report.py'|'$(pwd)/report.py'|' boot.sh
	sed -i 's|'./alert.py'|'$(pwd)/alert.py'|' boot.sh

deps:
	sudo apt-get update
	sudo apt-get install build-essential python-dev

adafruitlib:
	git clone https://github.com/adafruit/Adafruit_Python_DHT.git
	cd Adafruit_Python_DHT && sudo python setup.py install

squid:
	git clone https://github.com/simonmonk/squid.git
	cd squid && sudo python setup.py install

clean:
	sudo rm -rf Adafruit_Python_DHT
	sudo rm -rf squid
