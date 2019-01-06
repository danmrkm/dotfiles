#!/bin/bash

CURRENT_DIR=`pwd`
TODAY=`date +%Y%m%d`
NOW=`date +%H%M%S`

# Check init.el 
if [ ! -e ${CURRENT_DIR}/init.el ]
then
    echo ${CURRENT_DIR}/init.el not found!.
    exit 1
fi

# Check backup dir
if [ ! -d ${CURRENT_DIR}/backup/${TODAY} ]
then
    mkdir -p ${CURRENT_DIR}/backup/${TODAY}
fi

# Check lisp dir
if [ ! -d ${CURRENT_DIR}/lisp ]
then
    echo ${CURRENT_DIR}/list not found!.
    exit 1    
fi

if [ ! -d ~/.emacs.d/lisp ]
then
    mkdir ~/.emacs.d/lisp
fi



# Make backup
if [ -e ~/.emacs.d/init.el ]
then
    cp ~/.emacs.d/init.el ${CURRENT_DIR}/backup/${TODAY}/${NOW}_init.el
fi

# Copy init.el
cp ${CURRENT_DIR}/init.el ~/.emacs.d/init.el

# Copy lisp file
cp ${CURRENT_DIR}/lisp/* ~/.emacs.d/lisp/
