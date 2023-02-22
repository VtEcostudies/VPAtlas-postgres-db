#!/bin/bash -x

filenput=$1
filename=vpatlas_$(date -d "today" +"%Y%m%d-%H%M").backup
filepath=/home/ubuntu/db/backup/
echo $filepath$filename

#copy $filenput to aws s3 as $filename
aws s3 cp $filepath$filenput s3://vpatlas.backup/$filename
