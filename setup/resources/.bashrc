# .bashrc
# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

# User specific environment
if ! [[ "$PATH" =~ "$HOME/.local/bin:$HOME/bin:" ]]
then
    PATH="$HOME/.local/bin:$HOME/bin:$PATH"
fi
export PATH

# User specific aliases and functions
source "$HOME/.cargo/env"


# CHANGE DEFAULT
export MANPAGER="sh -c 'col -bx | bat -l man -p'" # BAT FOR MANPAGES
export EDITOR='micro' # DEFAULT EDITOR

# SHORTS
alias mc="micro"
alias hs="history"
alias cls="clear"

alias updoot="dnf -y upgrade"
alias install="dnf install"

alias unpack="tar -xvf"
alias pack="tar -cvf"

alias home="cd ~/"
alias desktop="cd ~/Desktop"
alias downloads="cd ~/Downloads"
alias ..="cd .."

# REPLACEMENTS
alias ps="procs"
alias ls="exa  -h --color=always --group-directories-first"
alias cat="bat"
alias find="fd"
alias top="htop"

alias now='date +"%T"'
alias time=now

## PROGRESS BARS FOR MV / CP
alias cp="rsync -r --progress"
alias mv="rsync -aP --remove-source-files"


alias reload='source ~/.bashrc'


# FUN
alias fucking="sudo"
alias weather="curl wttr.in/Rzeszów"

on_startup()
{
	now=$(date +"%T")
	
	echo "$now"
}
on_startup


export PS1="[\[$(tput sgr0)\]\[\033[38;5;160m\]\u\[$(tput sgr0)\]@\[$(tput sgr0)\]\[\033[38;5;11m\]\h\[$(tput sgr0)\] \W]\\$ \[$(tput sgr0)\]"