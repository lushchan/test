## wordpressinstaller
WordPress autoinstaller

## Run: 

Just run this script from root directory of domain

## params:
`-m - for manual mode`

`-f - automatic mode`

#
## Manual mode(-m):
Manual input database credentials
## Automatic mode(-f):
Auto create database, user and password from current path

examples:

`if path /home/ftpaccess/my-domain.com/www/`

`database name: wpmy_domaincom`

`database user(limited by 16 characters): wpumy_domaincom`


## Notes: 

File structure mus be like this `/home/username/domain.com/`

Document root must be like `www/html/public_html`

Database user name skiped or replaced specific characters like `"-","."`

MySQL root password must be saved in `~/.my.cnf` [WHAT???](https://ruhighload.com/my.cnf)
