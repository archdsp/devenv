#
# ~/.bash_profile
#

function set_packages()
{
    declare -A cmds
    cmds=([git]="git" [gpg]="gnupg" [scrot]="scrot" [xclip]="xclip" [glow]="glow")
    for cmd in "${!cmds[@]}"; do
        if [ -z "$(type -all $cmd)" ]; then
            if [ $cmd == 'glow' ]; then
                echo 'deb [trusted=yes] https://repo.charm.sh/apt/ /' | sudo tee /etc/apt/sources.list.d/charm.list
                sudo apt update && sudo apt install glow
            fi
            sudo apt-get -y install ${!cmds[$cmd]}
        else
            echo $cmd commad exist. Package ${!cmds[$cmd]} is intalled
        fi
    done
}

function set_git()
{
    export GIT_PS1_SHOWUPSTREAM="verbose name"
    export GIT_PS1_DESCRIBE_STYLE="branch"
    export GIT_PS1_SHOWCOLORHINTS="true" 

    git config --global init.templateDir ~/.git-templates

    source /usr/share/git/completion/git-completion.bash
    source /usr/share/git/completion/git-prompt.sh
}

function set_gpg()
{
    if [ -f "~/.gnupg/public_jisu.pgp" ];then
        gpg --import ~/.gnupg/public_jisu.pgp
    else
        gpg --auto-key-locate $1 --locate-keys $2
    fi

    if [ -f "~/.gnupg/private_jisu.pgp" ];then
        gpg --import ~/.gnupg/private_jisu.pgp
        git config --global user.signKey `gpg --list-key | awk 'FNR == 4 {gsub(/ /,"");print}'`
    fi
}

function myclip()
{
    scrot -s -q 100 foo.png;
    xclip -selection c -t image/png < foo.png ;
    rm foo.png;
}

function myhelp()
{
    echo "myclip, set_gpg, set_git, set_packages available"
}

export GPG_TTY=$(tty)
export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)
export GTK_IM_MODULE=ibus
export XMODIFIERS=@im=ibus
export QR_IM_MODULE=ibus

export LANG=ko_KR.UTF-8

# set bell-style none

[[ -f ~/.bash_aliases ]] &&  . ~/.bash_aliases
[[ -f ~/.bashrc ]] && . ~/.bashrc

