<VirtualHost *:80>

 ServerName  localhost.simscientists.com
 ServerAlias *.localhost.simscientists.com
 ServerAdmin webmaster@localhost.simscientists.com

 DocumentRoot /d/simscientists/public
 RailsEnv development

 <Directory />
  Options FollowSymLinks
  AllowOverride None
  Order allow,deny
  allow from all
 </Directory>

 LogLevel warn
 ErrorLog  /var/log/apache2/localhost.simscientists.com/error.log
 CustomLog /var/log/apache2/localhost.simscientists.com/access.log combined

</VirtualHost>
