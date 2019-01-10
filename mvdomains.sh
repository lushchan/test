#!/bin/bash
vim list
cat /etc/redhat-release
####CREATE DIRS#####
dir=''
while [ "$dir" = "" ]; do
    echo -n "Ticket number for backups dirs. Do not use this script if it is not C7 "
    read dir
    if [ -n "$dir" ]; then
        mkdir -p /home/support/lmr/$dir
        mkdir -p /home/support/lmr/$dir/domains/
        mkdir -p /home/support/lmr/$dir/httpd/
        mkdir -p /home/support/lmr/$dir/nginx/
        mkdir -p /home/support/lmr/$dir/sql/
    fi
done
####MOVE ACTIONS#######
cat ./list | while read domain
do
mv /home/*/$domain /home/support/lmr/$dir/domains/
mv /etc/httpd/vhosts.d/*/$domain\.conf /home/support/lmr/$dir/httpd/
mv /etc/nginx/vhosts.d/*/$domain\.conf /home/support/lmr/$dir/nginx/
####CHECK WP DATABASES###
grep DB_NAME /home/*/$domain/www/wp-config.php | sed "s/define('DB_NAME', '//g" | sed "s/');.*//g" | sed "s/.*\.php://g" > sqlist
done
cat ./sqlist | while read sqlist
do
mysqldump --routines --events --lock-tables $sqlist > /home/support/lmr/$dir/sql/$sqlist\.sql
done
