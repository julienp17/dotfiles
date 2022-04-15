# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

if [ -f $HOME/.bash_aliases ]; then
    . $HOME/.bash_aliases
fi

export DISPLAY=$(grep -m 1 nameserver /etc/resolv.conf | awk '{print $2}'):0.0
export PULSE_SERVER=tcp:$(grep -m 1 nameserver /etc/resolv.conf | awk '{print $2}')
export DISTRO_DNS=$(cat /etc/resolv.conf | grep nameserver | awk '{print $2; exit;}')
export WIN_HOME="/mnt/c/Users/julie/"

WINDOWS_USERNAME="julie"

export LIBGL_ALWAYS_INDIRECT=1
export BASHRC_PATH="$HOME/.bashrc"
export PATH="$PATH:/mnt/c/Windows/System32:/mnt/c/Users/${WINDOWS_USERNAME}/AppData/Local/Programs/Microsoft VS Code/bin"

################################## HISTORY ##################################
# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"
##################################   GCC ##################################

# colored GCC warnings and errors
export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

################################## PS1 ##################################
# get current branch in git repo
function parse_git_branch() {
	BRANCH=`git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/'`
	if [ ! "${BRANCH}" == "" ]
	then
		STAT=`parse_git_dirty`
		echo "[${BRANCH}${STAT}]"
	else
		echo ""
	fi
}

# get current status of git repo
function parse_git_dirty {
	status=`git status 2>&1 | tee`
	dirty=`echo -n "${status}" 2> /dev/null | grep "modified:" &> /dev/null; echo "$?"`
	untracked=`echo -n "${status}" 2> /dev/null | grep "Untracked files" &> /dev/null; echo "$?"`
	ahead=`echo -n "${status}" 2> /dev/null | grep "Your branch is ahead of" &> /dev/null; echo "$?"`
	newfile=`echo -n "${status}" 2> /dev/null | grep "new file:" &> /dev/null; echo "$?"`
	renamed=`echo -n "${status}" 2> /dev/null | grep "renamed:" &> /dev/null; echo "$?"`
	deleted=`echo -n "${status}" 2> /dev/null | grep "deleted:" &> /dev/null; echo "$?"`
	bits=''
	if [ "${renamed}" == "0" ]; then
		bits=">${bits}"
	fi
	if [ "${ahead}" == "0" ]; then
		bits="*${bits}"
	fi
	if [ "${newfile}" == "0" ]; then
		bits="+${bits}"
	fi
	if [ "${untracked}" == "0" ]; then
		bits="?${bits}"
	fi
	if [ "${deleted}" == "0" ]; then
		bits="x${bits}"
	fi
	if [ "${dirty}" == "0" ]; then
		bits="!${bits}"
	fi
	if [ ! "${bits}" == "" ]; then
		echo " ${bits}"
	else
		echo ""
	fi
}

export PROMPT_COMMAND=__prompt_command
function __prompt_command() {
    local EXIT="$?"
    PS1=""

    RESET_COLOR="\[\e[m\]"
    RED_BOLD="\[\e[1;31m\]"
    GREEN_BOLD="\[\e[1;32m\]"
    YELLOW_BOLD="\[\e[1;33m\]"
    BLUE_BOLD="\[\e[1;34m\]"

    EXIT_CODE="\`nonzero_return\`"
    CURRENT_DIRECTORY="\w"
    GIT_STATUS="\`parse_git_branch\`"
    END_PROMPT="\\$"

    if [ $EXIT == 0 ]; then
        PS1+="${GREEN_BOLD}"
    else
        PS1+="${RED_BOLD}"
    fi
    PS1+="[${EXIT}] "
    PS1+="${BLUE_BOLD}${CURRENT_DIRECTORY} "
    PS1+="${YELLOW_BOLD}${GIT_STATUS} "
    PS1+="${GREEN_BOLD}${END_PROMPT} "
    PS1+="${RESET_COLOR}"
}
[ -f "/home/julien/.ghcup/env" ] && source "/home/julien/.ghcup/env" # ghcup-env

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

eval "$(direnv hook bash)"
