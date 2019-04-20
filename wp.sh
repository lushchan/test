#!/bin/bash -e
if [[ -z $1 ]]; then
echo "Error: input parameter expected."
echo "Usage: 
-m - manual mode
-f - automatic mode
README - https://github.com/lushchan/wordpressinstaller/blob/master/README.md"
exit
fi
while [ -n "$1" ]
do
case "$1" in
-m)
clear
echo "============================================"
echo "WordPress Installer manual mode"
echo "============================================"
echo "Database Name: "
read -e dbname
echo "Database User: "
read -e dbuser
echo "Database Password: "
stty -echo
read -e dbpass
stty echo;;
-f)
clear
echo "============================================"
echo "WordPress Installer automatic mode"
echo "============================================"
dbname=wp`echo $PWD | cut -d / -f 4| sed -e 's/-/_/g'|sed 's|\.||g'`
dbuser=wpu`echo $PWD | cut -d / -f 4|cut -c 1-13 | sed 's|-|_|g'|sed 's|\.||g'`
dbpass=`pwgen 12 1`
mysql -e "CREATE DATABASE ${dbname} /*\!40100 DEFAULT CHARACTER SET utf8 */;"
mysql -e "CREATE USER ${dbuser}@localhost IDENTIFIED BY '${dbpass}';"
mysql -e "GRANT ALL PRIVILEGES ON ${dbname}.* TO '${dbuser}'@'localhost';"
mysql -e "FLUSH PRIVILEGES;"
;;
*) echo "$1 - unknown parametr" 
exit;;
esac  
shift
done
echo "============================================"
echo "Install WordPress."
echo "============================================"
stty echo
DIR=../www
DIR2=../html
DIR3=../public_html
if [ -d $DIR ] || [ -d $DIR2 ] || [ -d $DIR3 ]; then
   echo "Current dir is $PWD. All looks fine"
else
   echo "Current dir is $PWD. You must be in the root directory like www or public_html" 
fi
echo "Continue? (y/n)"
read -e run
if [ "$run" == n ] ; then
exit
else
echo "============================================"
echo "Domains - OK. Downloading"
echo "============================================"
curl -O https://wordpress.org/latest.tar.gz
tar -zxvf latest.tar.gz
cd wordpress
cp -rf . ..
cd ..
rm -R wordpress
cp wp-config-sample.php wp-config.php
perl -pi -e "s/database_name_here/$dbname/g" wp-config.php
perl -pi -e "s/username_here/$dbuser/g" wp-config.php
perl -pi -e "s/password_here/$dbpass/g" wp-config.php
wpowner=`stat -c %U .`
chown -R $wpowner:$wpowner $PWD
mkdir wp-content/uploads
chmod 777 wp-content/uploads
echo 'php_flag engine off' >> wp-content/uploads/.htaccess
rm latest.tar.gz
rm wp.sh
echo "========================="
echo "Installation is complete."
echo "Database Name: $dbname "
echo "Database User: $dbuser "
echo "Database Password: $dbpass "
echo "========================="
fi
exit
