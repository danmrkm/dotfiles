autoload -U compinit
compinit
autoload -U select-word-style
select-word-style bash

bindkey -e

if [ -e ~/.zprofile ]
then
    source ~/.zprofile
fi
