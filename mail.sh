#!/bin/bash
#change hostname
sudo hostnamectl set-hostname mailserver
sudo rm /etc/hosts
echo "127.0.0.1 localhost" | sudo tee /etc/hosts
echo "127.0.0.1 mailserver.proyect.cf mailserver" | sudo tee -a /etc/hosts
#update
sudo apt-get update
sudo apt-get upgrade -y
#users
sudo useradd -m test1
echo test1:qweR1234 | sudo chpasswd
sudo useradd -m test2
echo test2:qweR1234 | sudo chpasswd
#postfix install
sudo wget https://raw.githubusercontent.com/Drayo-git/Proyect-ASIX/main/postfix-conf.sh
sudo sh postfix-conf.sh
sudo apt-get install -q postfix -y
sudo postconf -e "home_mailbox= Maildir/"

#dovecot install
sudo apt-get install dovecot-core dovecot-imapd dovecot-pop3d -y
sudo wget https://raw.githubusercontent.com/Drayo-git/Proyect-ASIX/main/10-auth.conf
sudo wget https://raw.githubusercontent.com/Drayo-git/Proyect-ASIX/main/10-mail.conf
sudo cp 10-mail.conf /etc/dovecot/conf.d/10-mail.conf
sudo cp 10-auth.conf /etc/dovecot/conf.d/10-auth.conf

#mysql install
sudo apt-get install mysql-server -y
sudo apt-get install mysql-server-core-8.0 -y
sudo apt-get install mysql-server-client-8.0 -y

#mysql conf
mysql -e "CREATE DATABASE roundcube;"
mysql -e "CREATE USER roundcube@localhost IDENTIFIED BY 'Puerta69%2A';"
mysql -e "GRANT ALL PRIVILEGES ON roundcube.* TO 'roundcube'@'localhost';"
mysql -e "FLUSH PRIVILEGES;"

#Rouncube configurations
sudo apt install php7.4 libapache2-mod-php7.4 php7.4-common php7.4-mysql php7.4-cli php-pear php7.4-opcache php7.4-gd php7.4-curl php7.4-cli php7.4-imap php7.4-mbstring php7.4-intl php7.4-soap php7.4-ldap php-imagick php7.4-xmlrpc php7.4-xml php7.4-zip -y
sudo pear install Auth_SASL2 Net_SMTP Net_IDNA2-0.1.1 Mail_mime Mail_mimeDecode
sudo wget https://github.com/roundcube/roundcubemail/releases/download/1.5.2/roundcubemail-1.5.2-complete.tar.gz
sudo tar -xvzf roundcubemail-1.5.2-complete.tar.gz
sudo mv roundcubemail-1.5.2 /var/www/roundcube
sudo rm -r /var/www/roundcube/installer
sudo wget https://raw.githubusercontent.com/Drayo-git/Proyect-ASIX/main/config.inc.php
sudo wget https://raw.githubusercontent.com/Drayo-git/Proyect-ASIX/main/defaults.inc.php
sudo mv defaults.inc.php /var/www/roundcube/config/defaults.inc.php
sudo mv config.inc.php /var/www/roundcube/config/config.inc.php
sudo sed -i "31 i $config['db_dsnw'] = 'mysql://roundcube:Puerta69%2A@${rdshost}/roundcube';" /var/www/roundcube/config/config.inc.php 
sudo chown -R www-data:www-data /var/www/roundcube/
sudo wget https://raw.githubusercontent.com/Tikijavi/Mail-terraform/main/004-roundcube.conf
sudo mv 004-roundcube.conf /etc/apache2/sites-available/004-roundcube.conf
sudo a2dissite 000-default.conf
sudo a2ensite 004-roundcube.conf
sudo a2enmod rewrite
sudo mysql -h ${rdshost} -u root -p"Puerta69%2A" 'roundcube' < /var/www/roundcube/SQL/mysql.initial.sql
sudo rm -rf /var/www/html/roundcube/installer
#reboot services
sudo systemctl restart postfix
sudo systemctl restart dovecot
sudo service apache2 restart
