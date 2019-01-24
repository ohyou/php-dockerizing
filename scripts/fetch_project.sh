#!/usr/bin/env bash

# $1 - project name under /work/www/
# $2 - storage address

mkdir -p /work/www/
rsync -a --ignore-existing root@"$2":/work/www/"$1" /work/www/