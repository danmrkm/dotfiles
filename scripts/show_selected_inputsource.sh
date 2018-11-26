#!/bin/bash

org_result=`defaults read ~/Library/Preferences/com.apple.HIToolbox AppleSelectedInputSources`
us=`echo ${org_result} |grep "U.S."|wc -l`
abc=`echo ${org_result} |grep "ABC"|wc -l`
japanese=`echo ${org_result} |grep "Japanese"|wc -l`

if [ ${us} -eq 1 ]
then
    echo 'U.S.'
elif [ ${abc} -eq 1 ]
then
    echo 'abc'
elif [ ${japanese} -eq 1 ]
then
    echo 'japanese'
fi

