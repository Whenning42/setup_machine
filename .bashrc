#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias grep='grep --color=auto'

function current_command {
  local history_line="$(history 1)"
  echo "${history_line##*([[:space:])+([[:digit:]])+([[:space:]])}"
}
# Set the window's title to the current running command.
PS0='\[\e]0;$(current_command)\a\]'
# Set the window's title back to xterm when a command finishes.
# Set the prompt to `[user@hostname working_dir] $`
PS1='\[\e]0;xterm\a\][\u@\h \W]\$ '

# Make the history large and use a single history across all bash instances.
shopt -s histappend
PROMPT_COMMAND='history -a;history -n'
HISTSIZE=10000000
HISTFILESIZE=10000000

# Alias `manh` to open the manpage in firefox
alias manh='man -Hfirefox'

# Alias `shutdown` and `reboot`
alias shutdown='sudo shutdown now'
alias reboot='sudo reboot'

# Set the default editor to vim
export EDITOR=vim
