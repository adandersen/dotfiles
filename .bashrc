# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

### XDG env vars https://specifications.freedesktop.org/basedir-spec/basedir-spec-latest.html
# I'm mostly using the defaults...
export XDG_CONFIG_HOME=~/.config                   # personal configuration files
export XDG_DATA_HOME=~/.local/share                # personal user data
export XDG_CONFIG_DIRS=/etc/xdg                    # system config search order, XDG_CONFIG_HOME is searched first
export XDG_DATA_DIRS=/usr/local/share:/usr/share   # search order of data, earlier first, XDG_DATA_HOME precedes this
export XDG_CACHE_HOME=~/.cache                     # runtime apps non-essential user data files
export XDG_RUNTIME_DIR=~/.runtime                  # runtime apps non-essential user runtime files. Must be deleted on logout or shutdown/reboot
export LANG=en_US.UTF-8 # program language
export LC_CTYPE=en_US.UTF-8 # programmatic character function rules, e.g. for tolower(), toupper(), isalpha()

export TERMINAL=kitty
export KUBE_EDITOR='vim'
export EDITOR='vim'

# --files: List files that would be searched but do not search
# --no-ignore: Do not respect .gitignore, etc...
# --hidden: Search hidden files and folders
# --follow: Follow symlinks
# --glob: Additional conditions for search (in this case ignore everything in the .git/ folder)
export FZF_DEFAULT_COMMAND='rg --files --no-ignore --hidden --follow --glob "!.venv/lib64/*" --glob "!.git/*"' # meant for fuzzy finder in vim
export FZF_DEFAULT_OPTS='--height 40% --reverse --border'

export PGPASSWORD=canopytax
export PATH=~/.poetry/bin:/usr/local/Cellar/openssl/1.0.2n/bin/openssl:$PATH
export PATH=~/go/bin/:$PATH
export PATH="/home/linuxbrew/.linuxbrew/bin:/home/linuxbrew/.linuxbrew/sbin${PATH+:$PATH}";
export HOMEBREW_PREFIX="/home/linuxbrew/.linuxbrew"; 
export HOMEBREW_CELLAR="/home/linuxbrew/.linuxbrew/Cellar";
export HOMEBREW_REPOSITORY="/home/linuxbrew/.linuxbrew/Homebrew";
export MANPATH="/home/linuxbrew/.linuxbrew/share/man${MANPATH+:$MANPATH}:";
export INFOPATH="/home/linuxbrew/.linuxbrew/share/info:${INFOPATH:-}";

### editing shortcuts
alias bp="vim ~/.bash_profile"
alias bpl="vim ~/.bash_profile_local"
alias brc="vim ~/.bashrc"
alias brcl="vim ~/.bashrc_local"
alias arc="vim ~/.config/awesome/rc.lua"
alias atheme="vim ~/.config/awesome/defaultCustom.lua"
alias scripts="cd ~/.local/scripts"
alias swaps="cd ~/.local/share/nvim/swap"

### application specific aliases
alias icat="kitty +kitten icat" # kitty terminal image viewer command
alias wallpaper="icat --place 300x125@0x0 --scale-up --z-index -1 ~/Documents/Wallpaper/obsidian.jpg"
alias tmux="TERM=xterm-256color tmux"
alias ll="ls -l --color=auto -1ahX"
if [ $(uname) = 'Darwin' ]; then
    alias ls="ls -GFash"
else
    alias ls="ls --color=auto -GFash"
fi
alias idea='~/.local/idea/bin/idea.sh'
### emacs shortcuts
alias e="emacsclient -nw -a ''"
alias ec="emacsclient -n -a ''"

### git shortcuts
alias st='git status'
alias log='git log'
alias dif="git diff --ignore-space-at-eol -w --word-diff=color" # the ignore-space setting ignores differences in operating system line endings, e.g. /r/n /r /n
alias gb="git checkout -b "


# https://unix.stackexchange.com/a/217223
if [ ! -S ~/.ssh/ssh_auth_sock ]; then  
    eval $(ssh-agent)
    ln -sf "$SSH_AUTH_SOCK" ~/.ssh/ssh_auth_sock
fi
export SSH_AUTH_SOCK=~/.ssh/ssh_auth_sock
ssh-add -l > /dev/null || ssh-add

src () {
	source ~/.bashrc
}

gbc () {
    # make it so git push will work without needing '-u origin $branch'
    # only needs to be done once, but here to get other scripts to work on a new machine
    git config --global push.default current 

	if [ "$1" = '-h' ] || [ "$1" = '--help' ]; then
		echo "Git Branch Checkout"
		echo "	gbc branchName commitMessage"
        return
    fi

    branch=$1
    shift
    commit_flags=
    if [ "$1" = '-n' ]; then
        commit_flags="$1"
        shift
    fi
    git checkout -b $branch
    echo 'commit'
    # the ${a:+"$a"} will set $a to emptiness (instead of the empty string of ''). 
    # if it uses the empty string then it would be git commit --verbose '' which causes git commit to error. It needs to be nothing at all.
    git commit --verbose ${commit_flags:+"$commit_flags"}
    echo 'pushing'
    # find gitlab url and open in default browser
    git push 2>&1 | grep https | awk '{print $2}' | xargs xdg-open > /dev/null
}

gpm () {
	if [ "$1" = '-h' ] || [ "$1" = '--help' ]; then
		echo "Git Pull Master"
		echo "	gpm # use this on a non-master branch: 1) checks out master 2) pull 3) deletes the branch currently on"
	else
		branch=$(git rev-parse --abbrev-ref HEAD)
		git checkout master
		git pull
		git branch -D $branch
	fi
}

git-prune-remote () {
    case "$1" in
        -h|--help) echo 'usage: git-prune-remote'
                   echo '  Deletes local branches that no longer exist on the remote server.' 
                   ;;
                   # The `git fetch -p` removes any remote-tracking references that no longer exist on the remote
                *) git fetch -p && for branch in $(git branch -vv | grep ': gone]' | awk '{print $1}'); do git branch -D $branch; done 
                   ;;
    esac
}

myhelp () {
	gbc -h
	gpm -h
    branch-remove -h
    git-prune-remote -h
    echo ""
    echo "src: sources ~/.bashrc"
	setjdk -h
	echo ""
	echo "Other Commands: "
    echo "Ripgrep find files: rf filename [directory(cwd by default)]"
	echo "Show Dependencies: gradle efile-service:dependencies --configuration compile"
    echo "duc ui ~ (after duc index ~) to show file space usage"
}

dc () {
	export MY_LOCAL_IP=$(myIP)
	sudo docker-compose "$@"
}

myIP () {
	ifconfig eth0 | grep -m1 inet | awk '{print $2}'
	#ifconfig en0 inet | grep inet | awk '{print $2}'
}

dclean () {
	docker rm -v $(docker ps -a -q -f status=exited); 
    docker rmi $(docker images -f 'dangling=true' -q);
}

removeFromPath () {
    export PATH=$(echo $PATH | sed -E -e "s;:$1;;" -e "s;$1:?;;")
}

# set and change java versions
setjdk () {
    if [ "$1" = "-h" ] || [ "$1" = "--help" ]; then
        echo "Set JDK"
        echo "  setjdk 1.8"
        echo "  setjdk 9"
    elif [ $# -ne 0 ]; then
        removeFromPath '/System/Library/Frameworks/JavaVM.framework/Home/bin'
        if [ -n "${JAVA_HOME+x}" ]; then
            removeFromPath $JAVA_HOME
        fi
        export JAVA_HOME=`/usr/libexec/java_home -v $@`
        export PATH=$JAVA_HOME/bin:$PATH
    fi
}

# ripgrep find file names
rf () {
    if [ -z "$2" ]; then
        rg --files | rg "$1"
    else
        rg --files "$2" | rg "$1"
    fi
}

rc () {
    redis-cli -p 505$1 -a canopytax
}

rci () {
    redis-cli -p 505$1 -a canopytax $2
}

# create a branch in all the arguments
git-create-branches () {
    local branch=
    while [ ! -z "$1" ]; do
        case "$1" in
            -b) shift
                branch=$1
                ;;
             *) cd "$1"
                echo "Entered folder $1"
                git checkout -b "$branch"
                cd - &> /dev/null
                ;;
        esac

        shift
    done
}

git-delete-branches () {
    local branch=
    while [ ! -z "$1" ]; do
        case "$1" in
            -b) shift
                branch=$1
                ;;
             *) cd "$1"
                echo "Entered folder $1"
                git checkout master
                git branch -D "$branch"
                git pull
                cd - &> /dev/null
                ;;
        esac

        shift
    done
}

branch-remove () {
    if [ "$1" = '-h' ]; then
        echo 'branch-remove branchName'
        echo '  operates in path ~/dev/code on all directories'
        return 0
    fi
    pushd . > /dev/null
    for file in $(command ls -1 ~/dev/code); do 
        cd ~/dev/code/$file
        git branch | grep $1 > /dev/null && git checkout $1 && gpm || echo failed $(pwd)
    done
    popd > /dev/null
}

man () {
    LESS_TERMCAP_md=$'\e[01;31m' \
    LESS_TERMCAP_me=$'\e[0m' \
    LESS_TERMCAP_us=$'\e[01;32m' \
    LESS_TERMCAP_ue=$'\e[0m' \
    LESS_TERMCAP_so=$'\e[45;93m' \
    LESS_TERMCAP_se=$'\e[0m' \

    command man "$@"
}

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

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

TERM=xterm-256color

color_my_prompt () 
{
    local __user_and_host="\[\033[01;32m\]\u@\h"
    local __cur_location="\[\033[01;34m\]\w"
    local __git_branch_color="\[\033[31m\]"
    #local __git_branch="\`ruby -e \"print (%x{git branch 2> /dev/null}.grep(/^\*/).first || '').gsub(/^\* (.+)$/, '(\1) ')\"\`"
    local __git_branch='`git branch 2> /dev/null | grep -e ^* | sed -E  s/^\\\\\*\ \(.+\)$/\(\\\\\1\)\ /`'
    local __prompt_tail="\[\033[33m\]$"
    local __last_color="\[\033[00m\]"
    #export PS1="$__user_and_host $__cur_location $__git_branch_color$__git_branch$__prompt_tail$__last_color "
    export PS1="$__cur_location $__git_branch_color$__git_branch$__prompt_tail$__last_color "
}
color_my_prompt

# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi
[ -f /usr/local/etc/bash_completion ] && . /usr/local/etc/bash_completion

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="/home/alan/.sdkman"
[[ -s "/home/alan/.sdkman/bin/sdkman-init.sh" ]] && source "/home/alan/.sdkman/bin/sdkman-init.sh"

[ -f ~/.fzf.bash ] && source ~/.fzf.bash

if [ -f ~/.bashrc_local ]; then
    source ~/.bashrc_local
fi

export NVM_DIR="$HOME/.config/nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

eval "$(starship init bash)"

