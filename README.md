# How to setup
## Initial Setup
```sh
git init
git remote add origin https://www.opencode.net/jisuchoi/devenv.git
git fetch --all
git reset --hard origin/master
```

## Apply

```sh
source ~/.bash_profile
set_packages
set_gpg <key server> <user@example.com>
set_git
```

## Use gpg instead ssh
```sh
echo `gpg -k --with-keygrip | egrep -i "Keygrip" | awk 'FNR == 1 {print $3}'` > ~/.gnupg/sshcontrol
ssh-add -L
```

# Troubleshoot
## Window <-> Linux, Freebsd eol problem
```sh
sed -i 's/\r//' <file-path>
```


# Setting list
## Shell
* bash runtime configuration : .bashrc
* user environment : bash_profile
* user alias : bash_alias

## IDE
* vim : .vimrc
* emacs : .emacs

## Git
* .gitconfig
* .git-template
* .gitmessage : Commit message template
* .gitignore
* .gitattribute
