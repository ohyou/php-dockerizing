#!/usr/bin/env bash

cp /work/config/nginx.conf /etc/nginx/
cp /work/config/nginx.conf-dist /etc/nginx/
cp /work/config/php.ini /etc/

service nginx restart
service php restart