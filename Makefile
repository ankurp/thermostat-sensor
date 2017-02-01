all: install

install:
	sudo pwd=$(pwd) sed 's|'boot.sh'|'$pwd/boot.sh'|' rc.local > /etc/rc.local
