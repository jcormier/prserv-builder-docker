#! /bin/bash

DATETAG=$(date +%Y-%m-%d)

docker build -t yocto-prserv:production-$DATETAG .
# sudo docker run -tid -p 34328:34328 yocto-prserv:production-$DATETAG