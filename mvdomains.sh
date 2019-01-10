#!/bin/bash
clear
vim list
echo "============================================"
echo "Your OS is" `cat /etc/redhat-release`
echo "Do not use this script if it is not C7"
echo -n "Please input your nickname:"
read sdir
echo "============================================"
####CREATE DIRS#####
dir=''
while [ "$dir" = "" ]; do
    echo -n "Ticket number for backups dirs:#"
    read dir
    if [ -n "$dir" ]; then
        mkdir -p /home/support/$sdir/$dir
        mkdir -p /home/support/$sdir/$dir/domains/
        mkdir -p /home/support/$sdir/$dir/httpd/
        mkdir -p /home/support/$sdir/$dir/nginx/
        mkdir -p /home/support/$sdir/$dir/sql/
    fi
done
echo "================================================================================"
echo "Backup dirs:`dir /home/support/$sdir/$dir` is created in your home dir"
echo "================================================================================"
####MOVE ACTIONS#######
cat ./list | while read domain
do
grep DB_NAME /home/*/$domain/www/wp-config.php | sed "s/define('DB_NAME', '//g" | sed "s/');.*//g" | sed "s/.*\.php://g" > sqlist
mv /home/*/$domain /home/support/$sdir/$dir/domains/
mv /etc/httpd/vhosts.d/*/$domain\.conf /home/support/$sdir/$dir/httpd/
mv /etc/nginx/vhosts.d/*/$domain\.conf /home/support/$sdir/$dir/nginx/
done
echo "============================================"
echo "List of finded databases:"
echo `cat ./sqlist`
echo "============================================"
cat ./sqlist | while read sqlist
do
mysqldump --routines --events --lock-tables $sqlist > /home/support/$sdir/$dir/sql/$sqlist\.sql
done
echo "============================================"
echo "DONE"
echo "============================================"
