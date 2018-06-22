### shortcuts
alias ll="ls -l --color=auto -1ahX"
alias ls="ls -GFash"
alias src="source ~/.bash_profile"
alias fr="ag --nogroup --print0 --smart-case --color-line-number \"1;36\" --color-path \"1;30\" --color-match \"1;31\" --ignore-dir tmp"
alias bp="vim ~/.bash_profile"
alias bpl="vim ~/.bash_profile_local"

export KUBE_EDITOR='vim'
export EDITOR='vim'

### emacs shortcuts
alias e="emacsclient -nw -a ''"
alias ec="emacsclient -c -n -a ''"

### git shortcuts
alias st='git status'
alias log='git log'
alias dif="git diff --ignore-space-at-eol -w --word-diff=color" # the ignore-space setting ignores differences in operating system line endings, e.g. /r/n /r /n
alias gb="git checkout -b "

gbc() {
	if [ "$#" -gt 2 ] ; then
        for i in $(seq 1 $#);
		do
			branch=${@: $i:1}
			git checkout -b $branch
			git commit --verbose \""${@: $i:1}"\"
			open $(git push -u origin $branch | grep -o 'https://.*$')
		done
	elif [ "$1" = '-h' ] || [ "$1" = '--help' ]; then
		echo "Git Branch Checkout"
		echo "	gbc branchName commitMessage"
	fi
}

gpm() {
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

myhelp() {
	gbc -h
	gpm -h
    setjdk -h
    echo ""
	echo "Other Commands: "
	echo "Show Dependencies: gradle efile-service:dependencies --configuration compile"
}

dcfunc() {
	export MY_LOCAL_IP=$(myIP)
	docker-compose "$@"
}
myIP() {
	ifconfig en0 inet | grep inet | awk '{print $2}'
}
alias dc=dcfunc

dclean() {
	docker rm -v $(docker ps -a -q -f status=exited); docker rmi $(docker images -f 'dangling=true' -q);
}
dstart() {
	docker-machine start default; eval $(docker-machine env default);
}

alias dstop="docker-machine stop default"

function color_my_prompt {
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

removeFromPath () {
    export PATH=$(echo $PATH | sed -E -e "s;:$1;;" -e "s;$1:?;;")
}

# set and change java versions
function setjdk() {
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

# http://rabexc.org/posts/using-ssh-agent
if [ -z "$SSH_AUTH_SOCK" ] ; then
    eval `ssh-agent`
    ssh-add
fi

[ -f /usr/local/etc/bash_completion ] && . /usr/local/etc/bash_completion

if [ -f ~/.xmodmaprc ]; then
    xmodmap ~/.xmodmaprc 
fi

if [ -f ~/.bash_profile_local ]; then
    source ~/.bash_profile_local
fi
