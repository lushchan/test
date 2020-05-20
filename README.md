## wordpressinstaller
WordPress autoinstaller

## Run params:
`-m domain.com - for manual mode`

`-f domain.com - automatic mode`

## Manual mode(-m):
Manual input database credentials
## Automatic mode(-f):
Auto create database, user and password from document root path

examples:

`if path /home/ftpaccess/my-domain.com/www/`

`database name: wpmy_domaincom`

`database user(limited by 16 characters): wpumy_domaincom`


## Notes: 

Database user name skiped or replaced specific characters like `"-","."`

MySQL root password must be saved in `~/.my.cnf` [WHAT???](https://ruhighload.com/my.cnf)
