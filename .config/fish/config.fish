set GPG_TTY (tty)
set SSH_AUTH_SOCK (gpgconf --list-dirs agent-ssh-socket)
set GIT_CURL_VERBOSE 1
set GIT_TRACE 1
set LESSCHARSET utf-8

function border --on-event fish_postexec
    string repeat --count $COLUMNS ─
end

if status is-interactive
    # Commands to run in interactive sessions can go here
end
