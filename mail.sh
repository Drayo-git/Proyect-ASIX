!/bin/bash
sudo service apparmor stop
sudo service apparmor teardown
sudo update-rc.d -f apparmor remove -y
sudo apt-get remove apparmor apparmor-utils -y
sudo apt-get install ntp ntpdate -y
wget https://raw.githubusercontent.com/Drayo-git/Proyect-ASIX/main/postfix-conf>
sudo sh postfix-conf.sh
sudo apt-get install -q postfix -y
sudo apt-get install postfix-mysql postfix-doc openssl mysql-client getmail4 rk>
sudo apt-get install amavisd-new spamassassin clamav clamav-daemon zoo unzip bz>
sudo service spamassassin stop
sudo update-rc.d -f spamassassin remove
sudo freshclam
sudo service clamav-daemon start
sudo apt-get install nginx -y
sudo service nginx start
sudo apt-get install php5-fpm -y
sudo apt-get install fcgiwrap -y
sudo apt-get install phpmyadmin -y
sudo apt-get install phpmyadmin -y
sudo apt-get install mailman
sudo apt-get install pure-ftpd-common pure-ftpd-mysql quota quotatool
sudo echo 1 > /etc/pure-ftpd/conf/TLS
sudo mkdir -p /etc/ssl/private/
openssl req -x509 -nodes -days 7300 -newkey rsa:2048 -keyout /etc/ssl/private/p>
chmod 600 /etc/ssl/private/pure-ftpd.pem
sudo service pure-ftpd-mysql restart
LABEL=cloudimg-rootfs / ext4 defaults,usrjquota=quota.user,grpjquota=quota.grou>
sudo apt-get install linux-image-extra-virtual
sudo apt-get install bind9 dnsutils
sudo apt-get install vlogger webalizer awstats geoip-database libclass-dbi-mysq>
sudo rm /etc/cron.d/awstats
sudo apt-get install build-essential autoconf automake1.9 libtool flex bison de>
cd /tmp
wget http://olivier.sessink.nl/jailkit/jailkit-2.17.tar.gz
tar xvfz jailkit-2.17.tar.gz
cd jailkit-2.17
sudo ./debian/rules binary
cd ..
sudo dpkg -i jailkit_2.17-1_*.deb
sudo rm -rf jailkit-2.17*
cd ..
sudo apt-get install fail2ban
sudo service apache2 stop
sudo apt-get remove apache2
sudo update-rd.d apache2 remove
sudo service nginx restart
cd /tmp
wget http://www.ispconfig.org/downloads/ISPConfig-3-stable.tar.gz
tar xfz ISPConfig-3-stable.tar.gz
cd ispconfig3_install/install/
