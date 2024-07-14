#!/bin/bash

# Were I am?
pw=$(pwd)

# Install php dependencies
apt-get install -y php bridge-utils apache2 libapache2-mod-php php php-soap php-xml

# phpVirtualBox files
tar -xf $pw/phpvbox.tar -c /var/www/html
chown -R www-data:www-data /var/www/html/phpvbox
chmod -R 755 /var/www/html/phpvbox
rm $pw/phpvbox.tar

# Move vbxwebserver service
mv vboxwebsvr.service /etc/systemd/system/
chmod 755 /etc/systemd/system/vboxwebsvr.service
systemctl daemon-reload
systemctl start vboxwebsvr.service
systemctl enable vboxwebsvr.service

# Restart apache server
systemctl restart apache2.service
