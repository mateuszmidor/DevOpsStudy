#!/usr/bin/env bash

# this script is run on webserver droplet once it is up and running
apt-get -y update
apt-get -y install nginx
export HOSTNAME=`curl -s http://169.254.169.254/metadata/v1/hostname` # this is special DigitalOcean-internal address
export PUBLIC_IPV4=`curl -s http://169.254.169.254/metadata/v1/interfaces/public/0/ipv4/address` # this is special DigitalOcean-internal address
echo "Hello from $HOSTNAME ($PUBLIC_IPV4)!<br /> Hit F5 to see how loadbalancer works" > /var/www/html/index.nginx-debian.html