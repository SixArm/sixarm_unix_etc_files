mkdir -p /d/sixarm-website
mkdir -p /var/log/apache2/localhost.sixarm.com
a2ensite localhost.sixarm.com
