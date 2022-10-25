#!/bin/bash
#
#  Faveo Helpdesk Docker Development Environment
#
#  Copyright (C) 2020 Ladybird Web Solution Pvt Ltd
#
#  Author Thirumoorthi Duraipandi & Viswash S
#  Email  vishwas.s@ladybirdweb.com thirumoorthi.duraipandi@gmail.com
#
#  This program is free software; you can redistribute it and/or modify
#  it under the terms of the GNU General Public License as published by
#  the Free Software Foundation; either version 2 of the License, or
#  (at your option) any later version.
#
#  This program is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#  GNU General Public License for more details.
#
#  You should have received a copy of the GNU General Public License
#  along with this program; if not, see <http://www.gnu.org/licenses>.


# Colour variables for the script.
red=`tput setaf 1`

green=`tput setaf 2`

yellow=`tput setaf 11`

skyblue=`tput setaf 14`

white=`tput setaf 15`

reset=`tput sgr0`

# Faveo Banner.

echo -e "$skyblue                                                                                                                         $reset"
sleep 0.05
echo -e "$skyblue                                        _______ _______ _     _ _______ _______                                          $reset"
sleep 0.05   
echo -e "$skyblue                                       (_______|_______|_)   (_|_______|_______)                                         $reset"
sleep 0.05
echo -e "$skyblue                                        _____   _______ _     _ _____   _     _                                          $reset"
sleep 0.05
echo -e "$skyblue                                       |  ___) |  ___  | |   | |  ___) | |   | |                                         $reset"
sleep 0.05
echo -e "$skyblue                                       | |     | |   | |\ \ / /| |_____| |___| |                                         $reset"
sleep 0.05
echo -e "$skyblue                                       |_|     |_|   |_| \___/ |_______)\_____/                                          $reset"
sleep 0.05
echo -e "$skyblue                                                                                                                         $reset"
sleep 0.05 
echo -e "$skyblue                               _     _ _______ _       ______ ______  _______  ______ _     _                            $reset"
sleep 0.05     
echo -e "$skyblue                             (_)   (_|_______|_)     (_____ (______)(_______)/ _____|_)   | |                            $reset"
sleep 0.05
echo -e "$skyblue                              _______ _____   _       _____) )     _ _____  ( (____  _____| |                            $reset"
sleep 0.05
echo -e "$skyblue                             |  ___  |  ___) | |     |  ____/ |   | |  ___)  \____ \|  _   _)                            $reset"
sleep 0.05
echo -e "$skyblue                             | |   | | |_____| |_____| |    | |__/ /| |_____ _____) ) |  \ \                             $reset"
sleep 0.05
echo -e "$skyblue                             |_|   |_|_______)_______)_|    |_____/ |_______|______/|_|   \_)                            $reset"
sleep 0.05
echo -e "$skyblue                                                                                                                         $reset"
sleep 0.05
echo -e "$skyblue                                                                                                                         $reset"
                                                                                        
                                                                                        
                                                                                        
echo -e "$yellow               This script configures LAMP Stack Development Environment on Ubuntu 20.04,22.04 Distro's $reset"
echo -e "                                                                                                          "
sleep 0.5

if readlink /proc/$$/exe | grep -q "dash"; then
	echo '&red This installer needs to be run with "bash", not "sh". $reset'
	exit 1
fi

# Checking for the Super User.

if [[ $EUID -ne 0 ]]; then
   echo -e "$red This script must be run as root user or with sudo privilege $reset"
   exit 1
fi

# Uninstalling existing or Older versions

echo "$skyblue Uninstalling existing or Older versions.....$reset"

apt-get purge php8.1* php7.3* php7.4* mariadb* nodejs* composer* apache2* -y

echo "$skyblue Updating Repository cache and Installing prerequisites.....$reset"

apt-get update; apt-get install software-properties-common unzip curl zip wget  nano snapd -y ; apt-get upgrade -y

systemctl enable snapd

systemctl start snapd

snap install phpstorm --classic

if [[ $? != 0 ]]; then
echo -e "\n";
echo -e "$red Prerequisite Installation failed check your Internet connection or contact Server Team. $reset"
echo -e "\n";
exit 1;
fi 

# Adding Required Repositories.

echo "$skyblue Adding Required Repositories. $reset"

add-apt-repository --yes ppa:ondrej/php ; add-apt-repository --yes ppa:ondrej/apache2 ; apt-get update

if [[ $? != 0 ]]; then
echo -e "\n";
echo -e "$red Adding Apache and PHP Repositories Failed contact Server Team. $reset"
echo -e "\n";
exit 1;
fi 

echo "$skyblue Updating MariaDB-10.6 Repository.$reset"

curl -LsS -O https://downloads.mariadb.com/MariaDB/mariadb_repo_setup 

bash mariadb_repo_setup --mariadb-server-version=10.6

if [[ $? != 0 ]]; then
echo -e "\n";
echo -e "$red Adding Mariadb-10.6 Repository Failed contact Server Team. $reset"
echo -e "\n";
exit 1;
fi 

rm -f mariadb_repo_setup

echo -e "\n";
read -p "$skyblue Enter the prefered version for Nodejs (Ex: 12.x,13.x,14.x etc..): $reset" nodejs_version
echo -e "\n";
echo -e "\n";
read -p "$skyblue Enter the prefered version for PHP (Ex: 7.3,8.1): $reset" php_version
echo -e "\n";
echo -e "\n";
read -p "$skyblue Enter Password for Database ROOT User: $reset" db_root_pw
echo -e "\n";
echo -e "\n";
read -p "$skyblue Enter a Domain Name of your choice to generate Self Signed Certificates: $reset" domain_name
echo -e "\n";

# Configuring and Installing Prefered version of Nodejs Repository

echo -e "$skyblue Installing Nodejs-$nodejs_version... $reset"
curl -sL https://deb.nodesource.com/setup_$nodejs_version | bash -
apt update ; apt install nodejs -y

if [[ $? != 0 ]]; then
echo -e "\n";
echo -e "$red Nodejs-$nodejs_version Installation Failed contact Server Team. $reset"
echo -e "\n";
exit 1;
fi 

# Installing Apache2

echo -e "$green Installing Apache2... $reset"

apt install apache2 -y

if [[ $? != 0 ]]; then
echo -e "\n";
echo -e "$red Apache2 Installation Failed contact Server Team. $reset"
echo -e "\n";
exit 1;
fi 

systemctl enable apache2
systemctl start apache2

# Installing MariaDB-10.6

echo -e "$green Installing MariaDB-10.6... $reset"

apt install mariadb-client-10.6 mariadb-server-10.6 -y

if [[ $? != 0 ]]; then
echo -e "\n";
echo -e "$red MariaDB-10.6 Installation Failed contact Server Team. $reset"
echo -e "\n";
exit 1;
fi 

systemctl enable mariadb
systemctl start mariadb

# Updating Database root user password
mysql -e "alter user root@localhost identified by '$db_root_pw'"

# Installing prefered version of PHP

if [[ $php_version == 7.3 ]]; then
echo -e "\n";
echo -e "$green Installing PHP-$php_version. $reset"
apt install -y php$php_version libapache2-mod-php$php_version php$php_version-mysql \
    php$php_version-cli php$php_version-common php$php_version-fpm php$php_version-soap php$php_version-gd \
    php$php_version-json php$php_version-opcache  php$php_version-mbstring php$php_version-zip \
    php$php_version-bcmath php$php_version-intl php$php_version-xml php$php_version-curl  \
    php$php_version-imap php$php_version-ldap php$php_version-gmp php$php_version-redis
echo -e "\n";
elif [[ $php_version == 8.1 ]]; then
echo -e "\n";
echo -e "$green Installing PHP-$php_version. $reset"
apt install -y php$php_version libapache2-mod-php$php_version php$php_version-mysql \
    php$php_version-cli php$php_version-common php$php_version-fpm php$php_version-soap php$php_version-gd \
    php$php_version-opcache  php$php_version-mbstring php$php_version-zip \
    php$php_version-bcmath php$php_version-intl php$php_version-xml php$php_version-curl  \
    php$php_version-imap php$php_version-ldap php$php_version-gmp php$php_version-redis
echo -e "\n";
fi



if [[ $? != 0 ]]; then
echo -e "\n";
echo -e "$red PHP-$php_version Installation Failed contact Server Team. $reset"
echo -e "\n";
exit 1;
fi 

# Installing HTML to PDF Plugin

echo -e "$green Installing HTML to PDF Plugin. $reset"

echo "deb http://security.ubuntu.com/ubuntu focal-security main" | sudo tee /etc/apt/sources.list.d/focal-security.list
apt-get update; apt install libssl1.1 -y

wget https://github.com/wkhtmltopdf/packaging/releases/download/0.12.6-1/wkhtmltox_0.12.6-1.focal_amd64.deb -P /var/www/

dpkg -i /var/www/wkhtmltox_0.12.6-1.focal_amd64.deb

apt --fix-broken install -y

rm -f /var/www/wkhtmltox_0.12.6-1.focal_amd64.deb

if [[ $? != 0 ]]; then
echo -e "\n";
echo -e "$red HTML to PDF Plugin Installation Failed contact Server Team. $reset"
echo -e "\n";
fi 


echo -e "$skyblue Installing latest version of composer... $reset"
php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
php -r "if (hash_file('sha384', 'composer-setup.php') === '55ce33d7678c5a611085589f1f3ddf8b3c52d662cd01d4ba75c0ee0459970c2200a51f492d557530c71c15d8dba01eae') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;"
if [[ $? != 0 ]]; then
echo -e "\n";
echo -e "$red Composer Hash verfication failed contact Server Team. $reset"
echo -e "\n";
exit 1;
fi

php composer-setup.php

if [[ $? != 0 ]]; then
echo -e "\n";
echo -e "$red Composer Installation failed contact Server Team. $reset"
echo -e "\n";
exit 1;
fi
php -r "unlink('composer-setup.php');"
mv composer.phar /usr/bin/composer

echo -e "$green Generating Certificates for $domain_name .....  $reset"
mkdir -p /etc/apache2/ssl
openssl ecparam -out /etc/apache2/ssl/faveoroot.key -name prime256v1 -genkey
openssl req -new -sha256 -key /etc/apache2/ssl/faveoroot.key -out /etc/apache2/ssl/faveoroot.csr -subj "/C=/ST=/L=/O=/OU=/CN="
openssl x509 -req -sha256 -days 7300 -in /etc/apache2/ssl/faveoroot.csr -signkey /etc/apache2/ssl/faveoroot.key -out /etc/apache2/ssl/faveorootCA.crt
openssl ecparam -out /etc/apache2/ssl/private.key -name prime256v1 -genkey
openssl req -new -sha256 -key /etc/apache2/ssl/private.key -out /etc/apache2/ssl/faveolocal.csr -subj "/C=IN/ST=Karnataka/L=Bangalore/O=Ladybird Web Solutions Pvt Ltd/OU=Development Team/CN=$domain_name"
openssl x509 -req -in /etc/apache2/ssl/faveolocal.csr -CA  /etc/apache2/ssl/faveorootCA.crt -CAkey /etc/apache2/ssl/faveoroot.key -CAcreateserial -out /etc/apache2/ssl/faveolocal.crt -days 7300 -sha256
openssl x509 -in /etc/apache2/ssl/faveolocal.crt -text -noout

cp /etc/apache2/ssl/faveorootCA.crt /usr/local/share/ca-certificates/

echo "127.0.0.1 $domain_name" >> /etc/hosts

update-ca-certificates

if [[ $? -eq 0 ]]; then
    echo -e "$green Certificates generated successfully for $domain_name $reset"
else
    echo -e "$red Certification generation failed. $reset"
    exit 1;
fi;

echo -e "$green Configuring phpMyAdmin .....  $reset"

wget https://files.phpmyadmin.net/phpMyAdmin/5.1.1/phpMyAdmin-5.1.1-all-languages.zip -P /usr/share/

unzip /usr/share/phpMyAdmin-5.1.1-all-languages.zip -d /usr/share

mv /usr/share/phpMyAdmin-5.1.1-all-languages /usr/share/phpmyadmin

rm -f /usr/share/phpMyAdmin-5.1.1-all-languages.zip

mkdir /usr/share/phpmyadmin/tmp

chown -R www-data:www-data /usr/share/phpmyadmin 

chmod 777 /usr/share/phpmyadmin/tmp 

cat <<EOF > /etc/apache2/conf-available/phpmyadmin.conf 
Alias /phpmyadmin /usr/share/phpmyadmin
Alias /phpMyAdmin /usr/share/phpmyadmin
 
<Directory /usr/share/phpmyadmin/>
   AddDefaultCharset UTF-8
   <IfModule mod_authz_core.c>
      <RequireAny>
      Require all granted
     </RequireAny>
   </IfModule>
</Directory>
 
<Directory /usr/share/phpmyadmin/setup/>
   <IfModule mod_authz_core.c>
     <RequireAny>
       Require all granted
     </RequireAny>
   </IfModule>
</Directory>
EOF

echo -e '<h1> This is the Test Page of your Faveo Development Environment </h1>' > /var/www/html/index.html

cat <<EOF  >/etc/apache2/sites-available/faveo-ssl.conf
<VirtualHost *:80>
    ServerName $domain_name
    DocumentRoot /var/www/html
    <Directory /var/www/html>
        Options Indexes FollowSymLinks
        AllowOverride All
        Require all granted
    </Directory>
    ErrorLog ${APACHE_LOG_DIR}/faveo-error.log
    CustomLog ${APACHE_LOG_DIR}/faveo-access.log combined
    RewriteEngine on
    RewriteCond %{SERVER_NAME} =$domain_name
    RewriteRule ^ https://%{SERVER_NAME}%{REQUEST_URI} [END,NE,R=permanent]
</VirtualHost>

<IfModule mod_ssl.c>
<VirtualHost *:443>
    ServerName  $domain_name
    DocumentRoot /var/www/html
    <Directory /var/www/html>
        Options Indexes FollowSymLinks
        AllowOverride All
        Require all granted
    </Directory>
    ErrorLog ${APACHE_LOG_DIR}/faveo-error.log
    CustomLog ${APACHE_LOG_DIR}/faveo-access.log combined
    SSLEngine on
    SSLCertificateFile /etc/apache2/ssl/faveolocal.crt
    SSLCertificateKeyFile /etc/apache2/ssl/private.key
    SSLCertificateChainFile /etc/apache2/ssl/faveorootCA.crt    
</VirtualHost>
</IfModule>
EOF

sed -i 's/file_uploads =.*/file_uploads = On/g' /etc/php/$php_version/apache2/php.ini
sed -i 's/allow_url_fopen =.*/allow_url_fopen = On/g' /etc/php/$php_version/apache2/php.ini
sed -i 's/short_open_tag =.*/short_open_tag = On/g' /etc/php/$php_version/apache2/php.ini
sed -i 's/memory_limit =.*/memory_limit = 256MB/g' /etc/php/$php_version/apache2/php.ini
sed -i 's/;cgi.fix_pathinfo=.*/cgi.fix_pathinfo = 0/g' /etc/php/$php_version/apache2/php.ini
sed -i 's/upload_max_filesize =.*/upload_max_filesize = 100M/g' /etc/php/$php_version/apache2/php.ini
sed -i 's/post_max_size =.*/post_max_size = 100M/g' /etc/php/$php_version/apache2/php.ini
sed -i 's/max_execution_time =.*/max_execution_time = 360/g' /etc/php/$php_version/apache2/php.ini

sed -i 's/file_uploads =.*/file_uploads = On/g' /etc/php/$php_version/fpm/php.ini
sed -i 's/allow_url_fopen =.*/allow_url_fopen = On/g' /etc/php/$php_version/fpm/php.ini
sed -i 's/short_open_tag =.*/short_open_tag = On/g' /etc/php/$php_version/fpm/php.ini
sed -i 's/memory_limit =.*/memory_limit = 256MB/g' /etc/php/$php_version/fpm/php.ini
sed -i 's/;cgi.fix_pathinfo=.*/cgi.fix_pathinfo = 0/g' /etc/php/$php_version/fpm/php.ini
sed -i 's/upload_max_filesize =.*/upload_max_filesize = 100M/g' /etc/php/$php_version/fpm/php.ini
sed -i 's/post_max_size =.*/post_max_size = 100M/g' /etc/php/$php_version/fpm/php.ini
sed -i 's/max_execution_time =.*/max_execution_time = 360/g' /etc/php/$php_version/fpm/php.ini

sed -i 's/file_uploads =.*/file_uploads = On/g' /etc/php/$php_version/cli/php.ini
sed -i 's/allow_url_fopen =.*/allow_url_fopen = On/g' /etc/php/$php_version/cli/php.ini
sed -i 's/short_open_tag =.*/short_open_tag = On/g' /etc/php/$php_version/cli/php.ini
sed -i 's/memory_limit =.*/memory_limit = 256MB/g' /etc/php/$php_version/cli/php.ini
sed -i 's/;cgi.fix_pathinfo=.*/cgi.fix_pathinfo = 0/g' /etc/php/$php_version/cli/php.ini
sed -i 's/upload_max_filesize =.*/upload_max_filesize = 100M/g' /etc/php/$php_version/cli/php.ini
sed -i 's/post_max_size =.*/post_max_size = 100M/g' /etc/php/$php_version/cli/php.ini
sed -i 's/max_execution_time =.*/max_execution_time = 360/g' /etc/php/$php_version/cli/php.ini

a2enmod rewrite

a2enmod ssl

a2enmod proxy_fcgi setenvif

a2dissite 000-default.conf

a2ensite faveo-ssl.conf

a2enconf php$php_version-fpm

a2enconf phpmyadmin 

systemctl restart php$php_version-fpm

systemctl restart apache2

echo "Your URL: https://$domain_name" >> /var/www/credentials.txt
echo "phpMyAdmin URL: https://$domain_name/phpmyadmin" >> /var/www/credentials.txt
echo "Database Username: root" >> /var/www/credentials.txt
echo "Database Password: $db_root_pw" >> /var/www/credentials.txt


if [[ $? -eq 0 ]]; then
    echo -e "\n"
    echo "$yellow ######################################################################### $reset"
    echo -e "\n"
    echo "$green You will find the below details saved in a file name $reset $skyblue crdentials.txt under /var/www/credentials.txt $reset"
    echo "$green Use the same Database Credentials to login to phpMyAdmin  $reset"
    echo "$green Faveo Development Environment installed successfully. Visit $reset $skyblue https://$domain_name from your browser. $reset"
    echo "$green Please save the following credentials. $reset"
    echo "$green phpMyAdmin URL: $reset $skyblue https://$domain_name/phpmyadmin $reset"
    echo "$green MariaDB Database Username:$reset $skyblue root $reset"
    echo "$green MariaDB Database root password: $reset $skyblue $db_root_pw $reset"
    echo "$green Web server Root Directory path: $reset $skyblue /var/www/html $reset"
    echo -e "\n"
    echo "#########################################################################"
else
    echo "Script Failed unknown error."
    exit 1;
fi