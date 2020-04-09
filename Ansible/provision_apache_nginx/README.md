# Install nginx and apache and setup simple welcome site using roles

## Run docker to play around with apache/nginx. See results on localhost:8080

```bash
docker run --name linux -d --rm -p 8080:80 -it linuxserver/openssh-server
docker exec -it linux bash
```

## Steps in this scenario

- run dockerized linux instances server_nginx and server_apache
- install python3 on both instances
- install website contents on both instances
- install and run nginx on sever_nginx
- install and run apache2 on server_apache

## Steps for nginx

```bash
apk update
apk upgrade
apk add nginx

# create the PID file folder as it doesnt exist on Alpine
mkdir /run/nginx

# create website configuration folders
mkdir /etc/nginx/sites-enabled
mkdir /etc/nginx/sites-available

# create file /etc/nginx/sites-available/mywebsite.com:
server {
  listen 80 ;
  listen [::]:80;
  root /var/www/mywebsite.com;  
  index index.html;  
  server_name localhost mywebsite.com www.mywebsite.com;  
  location / {
    try_files $uri $uri/ =404;
  }
}

# enable the website
sed -i '/^http/ a include /etc/nginx/sites-enabled/*;' /etc/nginx/nginx.conf # append line after 'http'
ln -s /etc/nginx/sites-available/mywebsite.com /etc/nginx/sites-enabled/mywebsite.com

# create website contents
mkdir /var/www/mywebsite.com
echo "Hello from nginx!" > /var/www/mywebsite.com/index.html

# check config
nginx -t

# run server
nginx

# test server
curl localhost:80
```

## Steps for apache

```bash
apk update
apk upgrade
apk add apache2

# create server config file under /etc/apache2/conf.d/mywebsite.conf:
<VirtualHost *:80>
  ServerName www.mywebsite.com
  ServerAlias mywebsite.com localhost
  ServerAdmin admin@mywebsite.com
  DocumentRoot /var/www/mywebsite.com
  ErrorLog /var/log/apache2/mywebsite.com-error.log
  CustomLog /var/log/apache2/mywebsite.com-access.log common
  DirectoryIndex index.html
</VirtualHost>
<Directory /var/www/mywebsite.com>
  Require all granted
</Directory>

# create website contents
mkdir /var/www/mywebsite.com
echo "Hello from apache2" > /var/www/mywebsite.com/index.html

# check config
httpd -t

# run server
httpd

# test server
curl localhost:80
```
