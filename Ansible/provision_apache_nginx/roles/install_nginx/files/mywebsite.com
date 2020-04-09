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