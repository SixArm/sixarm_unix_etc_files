<VirtualHost *:80>

 ServerName  localhost.joelparkerhenderson.com
 ServerAlias *.localhost.joelparkerhenderson.com
 ServerAdmin webmaster@localhost.joelparkerhenderson.com

 DirectoryIndex index.html
 DocumentRoot /d/joelparkerhenderson-website

 <Directory />
  Options FollowSymLinks
  AllowOverride None
  Order allow,deny
  allow from all
 </Directory>

 LogLevel warn
 ErrorLog  /var/log/apache2/localhost.joelparkerhenderson.com/error.log
 CustomLog /var/log/apache2/localhost.joelparkerhenderson.com/access.log combined

</VirtualHost>
