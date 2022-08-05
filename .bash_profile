#
# ~/.bash_profile
#

function set_packages()
{
    . /etc/os-release

    unset distro_pkgmgr
    unset cmds
    declare -A distro_pkgmgr
    declare -A cmds

    distro_pkgmgr=([arch]='pacman -Syu' [ubuntu]='apt install -y')
    pkgmgr="sudo `echo ${distro_pkgmgr[$ID]}`"

    cmds=( \
        [git]="git=${pkgmgr} git" \
        [gpg]="gnupg=${pkgmgr} gnupg" \
        [scrot]="scrot=${pkgmgr} scrot" \
        [xclip]="xclip=${pkgmgr} xclip" \
        [glow]="glow=echo 'deb [trusted=yes] https://repo.charm.sh/apt/ /' | 
                     sudo tee /etc/apt/sources.list.d/charm.list;
                     sudo apt-get -y install" \
        )

    for cmd in "${!cmds[@]}"; do
        if [ -z "$(type -all $cmd)" ]; then
            record=${cmds[$cmd]}
            # pkgname=${record%%=*}
            install_cmd=${record#*=}
            # echo $pkgname $install_cmd
            eval $install_cmd
        else
            echo $cmd command exist.
        fi
    done
}

function set_git()
{
    export GIT_PS1_SHOWUPSTREAM="verbose name"
    export GIT_PS1_DESCRIBE_STYLE="branch"
    export GIT_PS1_SHOWCOLORHINTS="true" 

    git config --global init.templateDir ~/.git-templates

    if [ -f  '/usr/share/git/completion/git-completion.bash' ]; then
        source /usr/share/git/completion/git-completion.bash
        source /usr/share/git/completion/git-prompt.sh
    fi
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

