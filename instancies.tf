# Claus de la instancia
resource "aws_key_pair" "keypair" {
    key_name    = var.key_pair
    #public_key  = "mykey.pub"
    public_key  = "${file("mykey.pub")}"
}

# Instància EC2 amb la instal·lació del wordpress
resource "aws_instance" "Mail" {
  depends_on = [aws_internet_gateway.public_internet_gw]
  ami           = var.ami_ec2
  instance_type = var.instance_type_ec2
  key_name      = aws_key_pair.keypair.key_name
  subnet_id = aws_subnet.public_subnet.id
  vpc_security_group_ids = [aws_security_group.SG_public_subnet.id]
  tags = {
     Name = "Mail"
  }

  user_data = <<EOF
         #! /bin/bash
         sudo apt-get update && sudo apt-get upgrade -y
         sudo dpkg-reconfigure -p critical dash
         sudo service apparmor stop
         sudo service apparmor teardown
         sudo update-rc.d -f apparmor remove -y
         sudo apt-get remove apparmor apparmor-utils -y
         sudo apt-get install ntp ntpdate -y
         debconf-set-selections <<< "postfix postfix/mailname string mefumounpiti.com"
         debconf-set-selections <<< "postfix postfix/main_mailer_type string 'Internet Site'"
         apt-get install --assume-yes postfix
         sudo apt-get install postfix-mysql postfix-doc openssl mysql-client getmail4 rkhunter binutils dovecot-imapd dovecot-pop3d dovecot-mysql dovecot-sieve -y
         sudo apt-get install amavisd-new spamassassin clamav clamav-daemon zoo unzip bzip2 arj nomarch lzop cabextract apt-listchanges libnet-ldap-perl libauthen-sasl-perl clamav-docs daemon libio-string-perl libio-socket-ssl-perl libnet-ident-perl zip libnet-dns-perl -y
         sudo service spamassassin stop
         sudo update-rc.d -f spamassassin remove
         sudo freshclam
         sudo service clamav-daemon start
         sudo apt-get install nginx -y
         sudo service nginx start
         sudo apt-get install php5-fpm -y
         sudo apt-get install fcgiwrap -y
         debconf-set-selections <<< "phpmyadmin phpmyadmin/dbconfig-install boolean true"
         
         sudo apt-get install phpmyadmin -y
         sudo apt-get install mailman 
 	     sudo apt-get install pure-ftpd-common pure-ftpd-mysql quota quotatool
         sudo echo 1 > /etc/pure-ftpd/conf/TLS
         sudo mkdir -p /etc/ssl/private/
         openssl req -x509 -nodes -days 7300 -newkey rsa:2048 -keyout /etc/ssl/private/pure-ftpd.pem -out /etc/ssl/private/pure-ftpd.pem
         chmod 600 /etc/ssl/private/pure-ftpd.pem
         sudo service pure-ftpd-mysql restart
         LABEL=cloudimg-rootfs	/	 ext4	defaults,usrjquota=quota.user,grpjquota=quota.group,jqfmt=vfsv0	0 0
         sudo apt-get install linux-image-extra-virtual
         sudo apt-get install bind9 dnsutils
         sudo apt-get install vlogger webalizer awstats geoip-database libclass-dbi-mysql-perl
         sudo rm /etc/cron.d/awstats
         sudo apt-get install build-essential autoconf automake1.9 libtool flex bison debhelper binutils-gold
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
         sudo php -q install.php
      EOF

 provisioner "local-exec" {
  command = "echo ${aws_instance.Mail.public_ip} > publicIP.txt"
 }

}

# Llençant la base de dades RDS
resource "aws_db_instance" "DataBase" {
  allocated_storage    = 20

#  max_allocated_storage = 100
  storage_type         = var.storage_type_db
  engine               = var.engine_type_db
  engine_version       = var.engine_version_db
  instance_class       = var.instance_type_db
  name                 = var.name_db
  username             = var.username_db
  password             = var.password_db
  parameter_group_name = var.group_db
  publicly_accessible = false
  db_subnet_group_name = aws_db_subnet_group.db_subnet.name
  vpc_security_group_ids = [aws_security_group.SG_private_subnet_.id]
  skip_final_snapshot = true

provisioner "local-exec" {
  command = "echo ${aws_db_instance.DataBase.endpoint} > DB_host.txt"
    }

}
