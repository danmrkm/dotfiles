#!/bin/bash

# GitHub settings
UNAME='danmrkm'
EMAIL='38092962+danmrkm@users.noreply.github.com'
EDITOR='emacs'

#Check gpg
if [ ! -e /usr/local/bin/gpg ]
then
    echo 'GPG not installed. Run "brew install gpg2"'
    exit
fi

#Check gpg-agent pinentry-mac
if [ ! -e /usr/local/bin/gpg-agent ] || [ ! -e /usr/local/bin/pinentry-mac ]
then
    echo 'gpg-agent or prientry-mac not installed. Run "brew install gpg-agent pinentry-mac"'
    exit
fi

# Check gpg-agent.conf
if [ ! -e ${HOME}/.gnupg/gpg-agent.conf ]
then
    echo 'gpg-agent.conf not found. Create conf file.'
    echo 'ex) '
    echo 'use-standard-socket'
    echo 'pinentry-program /usr/local/bin/pinentry-mac'
    exit
fi

# Get GPG signature
GPGSIG=`LANG=C gpg --list-signatures |awk 'length($2) == 16 {print $2}'|head -1`

echo '### This script gives git config for GitHub account. ###'

echo '### Show current local config list. ###'
git config --local -l
echo '======================================'
echo '### Show current global config list. ###'
git config --global -l
echo '======================================'

echo '### Set local git config. ###'
git config --local user.name ${UNAME}
git config --local user.email ${EMAIL}
git config --local core.editor ${EDITOR}
git config --local gpg.program /usr/local/bin/gpg
git config --local user.signingkey ${GPGSIG}
git config --local commit.gpgsign true

echo '### Show result local config list. ###'
git config --local -l


