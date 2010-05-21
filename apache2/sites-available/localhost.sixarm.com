<VirtualHost *:80>

 ServerName  localhost.sixarm.com
 ServerAlias *.localhost.sixarm.com
 ServerAdmin webmaster@localhost.sixarm.com

 DirectoryIndex index.html
 DocumentRoot /d/sixarm-website

 <Directory />
  Options FollowSymLinks
  AllowOverride None
  Order allow,deny
  allow from all
 </Directory>

 LogLevel warn
 ErrorLog  /var/log/apache2/localhost.sixarm.com/error.log
 CustomLog /var/log/apache2/localhost.sixarm.com/access.log combined

</VirtualHost>
