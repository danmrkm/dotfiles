#!/bin/bash

CURRENT_DIR=`pwd`
TODAY=`date +%Y%m%d`
NOW=`date +%H%M%S`

# Check init.el 
if [ ! -e ${CURRENT_DIR}/init.el ]
then
    echo ${CURRENT_DIR}/init.el not found!.
    exit
fi

# Check backup dir
if [ ! -d ${CURRENT_DIR}/backup/${TODAY} ]
then
    mkdir -p ${CURRENT_DIR}/backup/${TODAY}
fi


# Make backup
if [ -e ~/.emacs.d/init.el ]
then
    cp ~/.emacs.d/init.el ${CURRENT_DIR}/backup/${TODAY}/${NOW}_init.el
    
fi

# Copy init.el
cp ${CURRENT_DIR}/init.el ~/.emacs.d/init.el

