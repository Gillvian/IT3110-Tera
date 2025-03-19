#!/bin/bash
apt-get update
apt-get install -y apache2
echo "TechNova Web App" > /var/www/html/index.html
systemctl start apache2
systemctl enable apache2
