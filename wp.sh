#!/bin/bash -e
clear
echo "============================================"
echo "MYSQL credentials is bellow"
echo "============================================"
dbname=wp`echo $PWD | cut -d / -f 4| sed -e 's/-/_/g'|sed 's|\.||g'`
dbuser=wpu`echo $PWD | cut -d / -f 4|cut -c 1-13 | sed 's|-|_|g'|sed 's|\.||g'`
dbpass=`pwgen 12 1`
echo "Database Name: $dbname "
echo "Database User: $dbuser"
echo "Database Password: $dbpass "
mysql -e "CREATE DATABASE ${dbname} /*\!40100 DEFAULT CHARACTER SET utf8 */;"
mysql -e "CREATE USER ${dbuser}@localhost IDENTIFIED BY '${dbpass}';"
mysql -e "GRANT ALL PRIVILEGES ON ${dbname}.* TO '${dbuser}'@'localhost';"
mysql -e "FLUSH PRIVILEGES;"
echo "============================================"
echo "Install WordPress"
echo "============================================"
stty echo
#typical root-dirs
DIR=../www
DIR2=../html
DIR3=../public_html
if [ -d $DIR ] || [ -d $DIR2 ] || [ -d $DIR3] ; then
   echo "Current dir is $PWD. All looks fine"
else
   echo "Current dir is $PWD. You must be in the root directory like www or public_html" 
exit
fi
echo "Continue? (y/n)"
read -e run
if [ "$run" == n ] ; then
exit
else
echo "============================================"
echo "Domains - OK."
echo "============================================"
#download & untar
curl -O https://wordpress.org/latest.tar.gz
tar -zxvf latest.tar.gz
#change dir to wordpress
cd wordpress
#copy file to parent dir
cp -rf . ..
#move back to parent dir
cd ..
#remove files from wordpress folder
rm -R wordpress
#create wp config
cp wp-config-sample.php wp-config.php
perl -pi -e "s/database_name_here/$dbname/g" wp-config.php
perl -pi -e "s/username_here/$dbuser/g" wp-config.php
perl -pi -e "s/password_here/$dbpass/g" wp-config.php
#create uploads folder and set permissions
wpowner=`stat -c %U .`
chown -R $wpowner:$wpowner $PWD
mkdir wp-content/uploads
chmod 777 wp-content/uploads
echo 'php_flag engine off' >> wp-content/uploads/.htaccess
#clean
rm latest.tar.gz
rm wp.sh
echo "========================="
echo "Installation is complete."
echo "========================="
fi
