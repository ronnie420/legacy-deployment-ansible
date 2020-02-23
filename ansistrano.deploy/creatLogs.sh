#!/bin/bash

grep -orhP '\K(/var/log/.*)' /var/www/html-$1/ | uniq | sed "s/[\'\"\;]//g" | sed s/")"//g | sed s/", \/\/absolute path to info logs"//g  | sed s/", \/\/absolute path to error logs"//g  | grep -v ".svn" | grep -v 2 | grep -v .swo | grep -v php.swn | grep -v php~ | grep -v  properties | grep -v '>' | sort | uniq > /var/logs.txt

while IFS="" read -r p || [ -n "$p" ]
do
  filename=$(basename -- "$p")
  extension="${filename##*.}"
  filename="${filename%.*}"
  if [ $extension = "log" ];
  then
     path=$p
     DIR="${path%/*}"
     mkdir -p $DIR
     touch $p
     chmod 777 $p
     #echo $filename ' -- ' $extension  
  else
     printf 'not a log file '
  fi

done < /var/logs.txt