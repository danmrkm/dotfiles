if test -f /etc/bashrc
then
    . /etc/bashrc
fi

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
		    touch $1
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


export PATH=/opt/local/bin:/opt/local/sbin:$PATH

alias ls='ls -G'
alias ssh-copy-id='~/scripts/ssh-copy-id'
alias emacs='emacs_singlerun'
alias plainpb='pbpaste|cat|pbcopy'
#alias emacs='emacs -q -l ~/.emacs.d/init_cmd.el'
alias emasc='emacs'
alias synccb='bash ~/scripts/synccb.sh'
export EDITOR='/usr/bin/emacs'
alias sublime='open -a Sublime\ Text'
alias python='/usr/local/bin/python3'

HISTSIZE=100000
HISTTIMEFORMAT='%Y/%m/%d %H:%M:%S '
