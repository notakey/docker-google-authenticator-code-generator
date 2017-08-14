#!/bin/bash 

docker rm -f totp &>/dev/null

docker run --rm  -p 80:80 \
 -v /etc/localtime:/etc/localtime \
 -v "$(pwd)/src:/var/www/html" \
 --name totp -i -t notakey/totp:latest 
