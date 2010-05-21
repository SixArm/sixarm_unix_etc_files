mkdir -p /d/simscientists-website
mkdir -p /var/log/apache2/localhost.simscientists.com
a2ensite localhost.simscientists.com
