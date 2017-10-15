FROM resin/rpi-raspbian:latest
ENTRYPOINT []

RUN apt-get -q update && \
    apt-get -qy install git python python-pip python-dev gcc make
RUN pip install rpi.gpio honcho

WORKDIR /usr/src/app
RUN git clone https://github.com/adafruit/Adafruit_Python_DHT.git
WORKDIR /usr/src/app/Adafruit_Python_DHT
RUN python setup.py install --force-pi2

WORKDIR /usr/src/app
RUN git clone https://github.com/simonmonk/squid.git
WORKDIR /usr/src/app/squid
RUN python setup.py install

WORKDIR /usr/src/app
ADD . .

CMD ["honcho", "start"]
