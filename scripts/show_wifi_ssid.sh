#!/bin/bash

# Wi-Fi デバイスを取得
wifidev=`networksetup -listallhardwareports |grep -A 1 Wi-Fi|awk  'NR==2 {print $2}'`

# SSID を取得
result=`/usr/sbin/networksetup -getairportnetwork ${wifidev}`
off_flag=`echo ${result} | grep off |wc -l`

# off_flag が 1 の場合、WiFi は OFF
if [ ${off_flag} -ne 0 ]
then
    echo 'Wi-Fi off'
else
    ssid=`echo ${result} | awk '{print $4}'`
    if [ ${ssid} == 'associated' ]
    then
	echo 'Not associated'
    else
	echo ${ssid}
    fi
    
fi
