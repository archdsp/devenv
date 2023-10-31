function lscolor
{
    for color in {0..255}; do
        print -P "%F{$color} $color %f"
    done
}

GPG_TTY=$(tty)
SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)
GIT_CURL_VERBOSE=1
GIT_TRACE=1
LESSCHARSET=utf-8

git_branch() {
    git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
}

setopt PROMPT_SUBST
PS1='%F{%(#.red.39)}%n%f@%F{208}%m%f$(git_branch) %F{39}%~%f
%(#.%(?.#.%F{red}#%f).%(?.%%.%F{red}%%%f)) '
PS1=$'%U${(r:$COLUMNS:: :)}%u'$PS1

PATH=$PATH:~/.config/emacs/bin
