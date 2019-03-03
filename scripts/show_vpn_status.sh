#!/bin/bash

# VPN 接続一覧を検索
result=`scutil --nc list|grep Connected|wc -l`

if [ ${result} -eq 1 ]
then
    echo 'VPN on'
else
    echo 'VPN off'
fi
