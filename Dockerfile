FROM resin/rpi-raspbian

RUN apt-get install build-essential python-dev

WORKDIR /usr/src/app
RUN git clone https://github.com/adafruit/Adafruit_Python_DHT.git
WORKDIR /usr/src/app/Adafruit_Python_DHT
RUN /usr/bin/python setup.py install

WORKDIR /usr/src/app
RUN git clone https://github.com/simonmonk/squid.git
WORKDIR /usr/src/app/squid
RUN /usr/bin/python setup.py install

WORKDIR /usr/src/app

COPY *.py /usr/src/app

RUN /usr/bin/python /usr/src/app/reading.py
CMD ["/usr/bin/python", "/usr/src/app/reading.py", "&", "/usr/bin/python", "/usr/src/app/alert.py", "&"]
