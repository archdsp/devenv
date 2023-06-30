#
# ~/.bash_profile
#


function set_packages()
{
    . /etc/os-release

    # Install yay package
    unset distro_pkgmgr install cmds check
    unset cmds
    declare -A distro_pkgmgr install cmds check

    distro_pkgmgr=([arch]='pacman' [ubuntu]='apt')
    install=([arch]='-Syu' [ubuntu]='-y install')
    check=([arch]='-Q' [ubuntu]='-qq list')

    pkgmgr_install="sudo `echo ${distro_pkgmgr[$ID]} ${install[$ID]}`"
    pkgmgr_check="`echo ${distro_pkgmgr[$ID]} ${check[$ID]}`"

    cmds=( \
        [git]="git=${pkgmgr_install} git" \
        [gnupg]="gnupg=${pkgmgr_install} gnupg" \
        [emacs]="emacs=${pkgmgr_install} emacs" \
        [scrot]="scrot=${pkgmgr_install} scrot" \
        [xclip]="xclip=${pkgmgr_install} xclip" \
        )

    for cmd in "${!cmds[@]}"; do
        if [ -z "$($pkgmgr_check $cmd)" ]; then
            record=${cmds[$cmd]}
            install_cmd=${record#*=}
            eval $install_cmd
        else
            echo $cmd command exist
        fi
    done
}

function install_yaypkgs()
{
    . /etc/os-release

    pacman -S --needed git base-devel
    git clone https://aur.archlinux.org/yay-bin.git $HOME/yay-bin
    cd yay-bin
    makepkg -si
    popd
    
    declare -A cmds
    cmds=([scrot]="scrot" [xclip]="xclip" [glow]="glow")
    for cmd in "${!cmds[@]}"; do
        if [[ -z "$(type -all $cmd)" || $?!="0" ]]; then
            echo Trying to install ${cmds[$cmd]}
            yay -Syu --noconfirm ${cmds[$cmd]}
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
    echo "First, run set_packages to install vim, emacs, git\n
    Second, run install_yaypkgs\n"
}

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
        # We have color support; assume it's compliant with Ecma-48
        # (ISO/IEC-6429). (Lack of such support is extremely rare, and such
        # a case would tend to support setf rather than setaf.)
        color_prompt=yes
    else
        color_prompt=
    fi
fi

# Console Style Constants
RST="\[\e[0m\]"           # Reset Styles
BOLD="\[\e[1m\]"          # Bold
UL="\[\e[4m\]"            # Underline
HIGHLIGHT="\[\e[7m\]"            # Highlight (inverse)
FG_BLACK="\[\e[90m\]"     # Foreground black
FG_RED="\[\e[91m\]"       # Foreground red
FG_GREEN="\[\e[92m\]"     # Foreground green
FG_YELLOW="\[\e[93m\]"    # Foreground yellow
FG_BLUE="\[\e[94m\]"      # Foreground blue
FG_MAGENTA="\[\e[95m\]"   # Foreground magenta
FG_CYAN="\[\e[96m\]"      # Foreground cyan
FG_WHITE="\[\e[97m\]"     # Foreground white
BG_BLACK="\[\e[100m\]"    # Background black
BG_RED="\[\e[101m\]"      # Background red
BG_GREEN="\[\e[102m\]"    # Background green
BG_YELLOW="\[\e[103m\]"   # Background yellow
BG_BLUE="\[\e[104m\]"     # Background blue
BG_MAGENTA="\[\e[105m\]"  # Background magenta
BG_CYAN="\[\e[106m\]"     # Background cyan
BG_WHITE="\[\e[107m\]"    # Background white

if [ "$color_prompt" = yes ]; then
    TIME="\n${FG_MAGENTA}[\d \t]${RST}"
    TERM127="`if [ \$? != 0 ]; then echo '${FG_RED}${BOLD}${HIGHLIGHT}!${RST}'; fi`"
    CWD="${FG_YELLOW}[job]: \j [dir]: \w${RST}${debian_chroot:+($debian_chroot)}"
    HOST="${FG_GREEN}${BOLD}\u${RST}${FG_WHITE}@${RST}${FG_CYAN}\h${RST}\$"
    GIT="`__git_ps1`"
    PS1="${TIME} ${TERM127} ${CWD} ${GIT} \n${HOST} "

else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi

unset color_prompt force_color_prompt

export GPG_TTY=$(tty)
export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)
export GTK_IM_MODULE=ibus
export XMODIFIERS=@im=ibus
export QR_IM_MODULE=ibus

export GIT_CURL_VERBOSE=1 
export GIT_TRACE=1

export LANG=ko_KR.UTF-8
export LESSCHARSET=utf-8

# set bell-style none

[[ -f ~/.bash_aliases ]] &&  . ~/.bash_aliases
[[ -f ~/.bashrc ]] && . ~/.bashrc
