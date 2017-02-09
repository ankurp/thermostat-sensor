all: install

install: clean deps adafruitlib squid
	sudo cp rc.local /etc/rc.local

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
