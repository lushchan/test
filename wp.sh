#!/bin/bash -e
if [[ -z $1 ]] || [[ -z $2 ]]; then
echo "Error: input parameter expected."
echo "Usage: 
-m domain.com - manual mode
-f domain.com - automatic mode
README - https://github.com/lushchan/wordpressinstaller/blob/master/README.md"
exit
fi

domain=$2
docroot=$(grep -r "$domain" /etc/nginx/ | grep root | awk '{print $(NF-1), $NF}'  | sed 's/root //g;s/;//g' | sed 's/^[ \t]*//g;s/[ \t]*$//g;s|/$||g' | sort -u | head -n 1)


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
      dbname=wp`echo $docroot | cut -d / -f 4| sed -e 's/-/_/g'|sed 's|\.||g'`
      dbuser=wpu`echo $docroot | cut -d / -f 4|cut -c 1-13 | sed 's|-|_|g'|sed 's|\.||g'`
      dbpass=`head /dev/urandom | tr -dc A-Za-z0-9 | head -c 13`
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
echo "Continue? (y/n)"
read -e run
if [ "$run" == n ] ; then
exit
else
   echo "============================================"
   echo "Domains - OK. Downloading" 
   echo "============================================"
   curl -O https://wordpress.org/latest.tar.gz
   tar -zxvf ./latest.tar.gz --strip 1 -C $docroot
   rm ./latest.tar.gz
   cp wp-config-sample.php wp-config.php
   perl -pi -e "s/database_name_here/$dbname/g" $docroot/wp-config.php
   perl -pi -e "s/username_here/$dbuser/g" $docroot/wp-config.php
   perl -pi -e "s/password_here/$dbpass/g" $docroot/wp-config.php
   wpowner=`stat -c %U .`
   chown -R $wpowner:$wpowner $docroot
   mkdir $docroot/wp-content/uploads
   chmod 777 $docroot/wp-content/uploads
   echo 'php_flag engine off' >> $docroot/wp-content/uploads/.htaccess
   rm latest.tar.gz
   rm wp.sh
   echo "==========================================================================="
   echo "Installed to $docroot"
   echo "Please use the following credentials for access to the WordPress Database: "
   echo "==========================================================================="
   echo "dbHost: localhost"
   echo "dbName: $dbname"
   echo "dbUser: $dbuser"
   echo "dbPassword: $dbpass"
   echo "==========================================================================="

fi
exit
