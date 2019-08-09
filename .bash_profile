# Load os default bashrc
if test -f /etc/bashrc
then
    . /etc/bashrc
fi

####### Function section #######

# function for Emacs.app
function emacs_singlerun () {

    local flag=False

    if [ `ps -u $USER |grep Emacs.app/Contents/MacOS/Emacs|grep -v grep|wc -l` -gt 0 ]
    then
	if [ $# -lt 3 ] && [ "`echo $1 |cut -c 1`" != "-" ]
	then
	    if [ "$2" = '&' ] || [ "$2" = '' ]
	    then
		if test ! -e $1
		then
		    echo "$1 is not found. Do you want to create a new file? [y/n]"
		    read answer
		    case "$answer" in
			y)
			    touch $1
			    ;;
			*)
			    echo 'Cancelled'
			    return 1
			    ;;
		    esac
		fi
		open -a Emacs.app $1
		flag=True
	    fi
	fi
    fi

    if [ $flag != True ]
    then
	/Applications/Emacs.app/Contents/MacOS/Emacs $*
    fi
}

# function for shellscript in scripts dir
function conv_scripts_to_bin () {

    if [ -d ${HOME}/scripts ]
    then
	for i in `ls ${HOME}/scripts | grep ".sh"|grep -v "~"`
	do
	    chmod u+x ${HOME}/scripts/${i}
	    binname=`echo ${i} |sed -e 's/\.sh//g'`

	    if [ ! -e ${HOME}/bin/${binname} ]
	    then
		ln -s ${HOME}/scripts/${i} ${HOME}/bin/${binname}
	    fi
	done
    fi

}

###### Enviroment variables ######

export PATH=/opt/local/bin:/opt/local/sbin:${HOME}/bin:$PATH
#export PS1='macbookpro:\W \u$ '
export EDITOR='/usr/bin/emacs'


###### Alias #######

alias ls='ls -G'
alias emacs='emacs_singlerun'
alias plainpb='pbpaste|cat|pbcopy'
alias emasc='emacs'
alias synccb='bash ~/scripts/synccb.sh'
alias sublime='open -a Sublime\ Text'
alias python='/usr/local/bin/python3'
alias proxyon='networksetup -setwebproxystate Ethernet on;networksetup -setsecurewebproxystate Ethernet on;'
alias proxyoff='networksetup -setwebproxystate Ethernet off;networksetup -setsecurewebproxystate Ethernet off'


###### Others configuration #######

HISTSIZE=100000
HISTTIMEFORMAT='%Y/%m/%d %H:%M:%S '

###### Initial run #######

conv_scripts_to_bin
