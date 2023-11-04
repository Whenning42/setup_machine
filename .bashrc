#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias grep='grep --color=auto'
PS1='[\u@\h \W]\$ '

# Make the history large and use a single history across all bash instances.
shopt -s histappend
PROMPT_COMMAND='history -a;history -n'
HISTSIZE=10000000
HISTFILESIZE=10000000

# Alias `manh` to open the manpage in firefox
alias manh='man -Hfirefox'

# Set the default editor to vim
export EDITOR=vim
