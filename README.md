# How to setup
## Initial Setup
```sh
git init
git remote add origin https://github.com/archdsp/devenv.git
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

## AI
### Claude Code
* .claude/CLAUDE.md : 전역 작업 규칙 (Anaconda 환경, WIP.md 기록, 브랜치 정책, 커밋 메시지 규칙 등 모든 프로젝트 공통)
* .claude/settings.json : Claude Code 사용자 설정
* 그 외 .claude 하위 디렉터리(projects, sessions, backups, telemetry, worktrees 등)는 런타임/민감 데이터이므로 추적하지 않음
