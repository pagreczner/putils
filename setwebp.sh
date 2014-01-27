#!/bin/sh
sudo networksetup -setwebproxy "Wi-Fi" idev 3128 off
ACTIVE_PROXY=
if [ "$1" == "" ]
  then
  ACTIVE_PROXY="on"
  else
  ACTIVE_PROXY=$1
fi      

if [ $ACTIVE_PROXY == "" ]
  then
  ACTIVE_PROXY="on"
fi
sudo networksetup -setwebproxystate "Wi-Fi" $ACTIVE_PROXY
