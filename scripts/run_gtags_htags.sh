#!/bin/bash

TARGET_DIR=${HOME}/git
EXCLUDE_DIR_ARRAY=("a" "b")

if [ $# -eq 1 ] && [ "$1" = "renew" ]
then
    RENEW_FLAG="true"
    echo 'Renew GTAGS'
else
    RENEW_FLAG='false'
fi

if [ ! -d ${TARGET_DIR} ]
then
    echo 'TARGET_DIR is not found or not directory.'
    exit
fi

if [ -e ${HOME}/.globalrc ]
then
    GTAGSCONF_FLAG="true"
else
    GTAGSCONF_FLAG="false"
fi

TEMPFILE=`mktemp`
echo '<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />' > ${TEMPFILE}

for i in `ls ${TARGET_DIR}`
do
    
    if ! echo ${EXCLUDE_DIR_ARRAY[@]} | grep -sq  "${i}" && [ -d ${TARGET_DIR} ]
    then
	echo $i
	cd ${TARGET_DIR}/${i}
	
	if [ ! -e ${TARGET_DIR}/${i}/GTAGS ] || [ ${RENEW_FLAG} = "true" ]
	then
	    if [ ${GTAGSCONF_FLAG} = "true" ]
	    then
		gtags --gtagsconf ${HOME}/.globalrc
	    else
		gtags
	    fi
	    
	else
	    if [ ${GTAGSCONF_FLAG} = "true" ]
	    then
		global -u --gtagsconf ${HOME}/.globalrc
	    else
		global -u
	    fi
	    
	fi
	    if [ ${GTAGSCONF_FLAG} = "true" ]
	    then
		htags -asnFo --html-header ${TEMPFILE}
	    else
		htags -asnFo --html-header ${TEMPFILE} --gtagsconf ${HOME}/.globalrc 
	    fi	


    else
	echo "Skip ${TARGET_DIR}/${i}"
	
    fi

done

rm ${TEMPFILE}
