#!/bin/bash

while true; do
  netstat -ap > old.txt
  sleep 5s
  netstat -ap > new.txt
  diff -y old.txt new.txt | grep -E '.<' >> change.txt
  
  while read line; do
    sed -i 's/..$//' change.txt
  done <change.txt
  while read line; do
    echo new.txt | grep "$line"
  done <change.txt
  
done
exit 0
