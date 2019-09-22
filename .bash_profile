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

# SSH hook for changing tmux window
function ssh_tmux() {
    this_window_name=`tmux display-message -p '#W'`
    ssh_host=`echo $@ | perl -ple 's/(^|\s)-[^\s] *[^\s]+//g' | cut -d" " -f2`
    logdir=${HOME}/.tmuxlog/${ssh_host}/`date +%Y%m%d`
    nowtime=`date +%H%M%S`

    # Load ssh host's tmux window name
    if [ -e ~/.ssh/tmux_config ]
    then
	load_window_name=`cat ~/.ssh/tmux_config | grep -v "#" | grep -E "^${ssh_host}\t" |cut -f 2`
	if [ ${load_window_name} ]
	then
	    window_name=${load_window_name}
	else
	    window_name=${this_window_name}
	fi
    else
	window_name=${this_window_name}
    fi

    # Check window_name is exsited
    result=`tmux list-window | grep " ${window_name}" | wc -l`
    if [ ${result} -ne 0 ]
    then
	pane_count=`tmux list-window | grep " ${window_name}" | head -1 | cut -d "(" -f 2 |cut -d " " -f 1`
	pane_number=`expr ${pane_count} - 1`
	new_pane_number=${pane_count}
    else
	# Create window
	tmux new-window -n ${window_name}
	pane_count=0
	pane_number=0
	new_pane_number=${pane_number}
    fi


    if [ ${pane_count} -ne 0 ]
    then
	if [ -z "${TMUXLOG}" ] || [ ! ${this_window_name} = ${window_name} ]
	then
            tmux  set-option default-terminal "screen" \; \
		  split-window -v -t "${window_name}.${pane_number}" \; \
		  select-layout even-vertical \; \
		  send-keys -t "${window_name}.${new_pane_number}" "TMUXLOG=1" C-m  \; \
		  send-keys -t "${window_name}.${new_pane_number}" "ssh $@" C-m     \; \
		  run-shell        "if [ ! -d ${logdir} ];then  mkdir -p ${logdir};fi" \; \
		  pipe-pane        "cat >> ${logdir}/${nowtime}.log" \; \
		  display-message  "Started logging to ${logdir}/${nowtime}.log)"
	else
            ssh $@
	fi
    else
        tmux  set-option default-terminal "screen" \; \
	      select-layout even-vertical \; \
	      send-keys -t "${window_name}.${new_pane_number}" "TMUXLOG=1" C-m  \; \
	      send-keys -t "${window_name}.${new_pane_number}" "ssh $@" C-m     \; \
	      run-shell        "if [ ! -d ${logdir} ];then  mkdir -p ${logdir};fi" \; \
	      pipe-pane        "cat >> ${logdir}/${nowtime}.log" \; \
	      display-message  "Started logging to ${logdir}/${nowtime}.log)"
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

if [[ ${TERM} = screen ]] || [[ ${TERM} = screen-256color ]]
then
    alias ssh=ssh_tmux
fi

###### Others configuration #######

HISTSIZE=100000
HISTTIMEFORMAT='%Y/%m/%d %H:%M:%S '

###### Initial run #######

conv_scripts_to_bin
