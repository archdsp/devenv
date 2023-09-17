function lscolor
{
    for color in {0..255}; do
        print -P "%F{$color} $color %f"
    done
}



zle_highlight=(default:bold)

NEWLINE=$'\n'
TIME="[%*]"
CWD="job: %N [dir]: %d"
GIT="${git_branch}"
HOST="%#"
PS1="%F{49} ${TIME} ${CWD} ${GIT} ${NEWLINE} ${HOST} %F{reset}"
