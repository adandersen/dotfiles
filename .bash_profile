source ~/.bashrc

export PATH=~/.local/bin:$PATH
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

export KUBE_EDITOR='vim'
export EDITOR='vim'
# --files: List files that would be searched but do not search
# --no-ignore: Do not respect .gitignore, etc...
# --hidden: Search hidden files and folders
# --follow: Follow symlinks
# --glob: Additional conditions for search (in this case ignore everything in the .git/ folder)
export FZF_DEFAULT_COMMAND='rg --files --no-ignore --hidden --follow --glob "!.venv/lib64/*" --glob "!.git/*"' # meant for fuzzy finder in vim

if [ -f ~/.local/bin/dropbox.py ]; then
    ~/.local/bin/dropbox.py start > /dev/null
else
    echo 'dropbox not installed at ~/.local/bin/dropbox.py, download it, chmod it, and put it there'
fi

# https://unix.stackexchange.com/questions/132065/how-do-i-get-ssh-agent-to-work-in-all-terminals
export SSH_AUTH_SOCK=~/.ssh/ssh-agent.$HOSTNAME.sock
ssh-add -l 2>/dev/null >/dev/null
if [ $? -eq 2 ]; then  # $? means return status code of last executed command
    echo "Starting ssh-agent on socket $SSH_AUTH_SOCK"
    ssh-agent -a "$SSH_AUTH_SOCK" >/dev/null
    eval `ssh-agent`
fi

# http://rabexc.org/posts/using-ssh-agent
#if [ -z "$SSH_AUTH_SOCK" ] ; then
#    eval `ssh-agent`
#fi

# map caps lock to esc and right alt to ctrl
# -r means file exists and is readable
[ -r ~/.Xmodmap ] && xmodmap ~/.Xmodmap 

if [ -f ~/.bash_profile_local ]; then
    source ~/.bash_profile_local
fi
