#!/bin/bash

SKIP_ADDR1=127.0.0.1
SKIP_ADDR2=169.254

ipaddr=""
counter=0

for ipadd in `ifconfig | grep inet |grep -v inet6 | awk '{print $2}'`
do
    ipadd_2ndoctet=`echo ${ipadd} | cut -c -7`

    if [ ${ipadd} = ${SKIP_ADDR1} ]
    then
	continue
    elif [ ${ipadd_2ndoctet} = ${SKIP_ADDR2} ]
    then
	continue
    fi

    if [ ${counter} -eq 0 ]
    then
	ipaddr="${ipadd}"
    else
	ipaddr="${ipaddr} | ${ipadd}"

    fi
    counter=`expr ${counter} + 1`
done

echo ${ipaddr}
