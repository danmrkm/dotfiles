autoload -U compinit
compinit

if [ -e ~/.zprofile ]
then
    source ~/.zprofile
fi

setopt share_history
