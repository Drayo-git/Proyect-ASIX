#!/bin/bash
#change hostname
sudo hostnamectl set-hostname mailserver
sudo rm /etc/hosts
echo "127.0.0.1 localhost" | sudo tee /etc/hosts
echo "127.0.1.1 mailserver.proyect.cf mailserver" | sudo tee -a /etc/hosts
echo "${aws_instance.Mail.public_ip} mailserver.proyect.cf mailserver" | sudo tee -a /etc/hosts
echo "${aws_instance.Mail.private_ip} mailserver.proyect.cf mailserver" | sudo tee -a /etc/hosts
#update
sudo apt-get update 
sudo apt-get upgrade -y
#user creation
sudo useradd -m test1
echo test1:qweR1234 | sudo chpasswd
sudo useradd -m test2
echo test1:qweR1234 | sudo chpasswd
