function lscolor
{
    for color in {0..255}; do
        print -P "%F{$color} $color %f"
    done
}

if [[ -x "/bin/vim" ]]; then
    EDITOR="/usr/bin/vim"			# needed for packages like cron
elif [[ -x "/bin/emacs" ]]; then
    EDITOR="/usr/bin/emacs"
elif [[ -x "/bin/vi" ]]; then
    EDITOR="usr/bin/vi"
elif [[ -x "/bin/nano" ]]; then
    EDITOR="/usr/bin/nano"			# needed for packages like cron
fi

export GPG_TTY="${TTY:-"$(tty)"}"
unset SSH_AGENT_PID
unset SSH_AUTH_SOCK
export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)

export GIT_CURL_VERBOSE=1
export GIT_TRACE=1
export GIT_PS1_SHOWUPSTREAM="verbose name"
export GIT_PS1_DESCRIBE_STYLE="branch"
export GIT_PS1_SHOWCOLORHINTS="true"

export LESSCHARSET=utf-8

git_branch() {
    git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
}

setopt PROMPT_SUBST
PS1='%F{%(#.red.39)}%n%f@%F{208}%m%f$(git_branch) %F{39}%~%f %?
%(#.%(?.#.%F{red}#%f).%(?.%%.%F{red}%%%f)) '
PS1=$'%U${(r:$COLUMNS:: :)}%u'$PS1

export PATH=$PATH:~/.config/emacs/bin
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/lib
