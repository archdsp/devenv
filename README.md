# How to setup
## Initial Setup
```sh
git init
git remote add origin https://github.com/archdsp/devenv.git
git fetch --all
git reset --hard origin/main
```

## Apply

```sh
source ~/.config/bash/bash_functions   # load helper functions
set_packages        # install git/gh/gnupg/emacs/tmux/zsh (+ OS-specific pinentry)
gpg_set_pinentry    # set OS-specific pinentry-program in ~/.gnupg/gpg-agent.conf
set_git             # set OS-specific credential.helper in ~/.gitconfig.local
```

> OS는 셸이 `uname`으로 런타임 감지(`$DOTFILES_OS`)하므로 zsh/bash 설정은 macOS·Ubuntu 공통입니다.
> 토큰/API 키 같은 비밀값은 추적되지 않는 `~/.config/zsh/secrets`에 둡니다(절대 커밋 금지).

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
## Shell (macOS / Ubuntu 공통, 런타임 OS 감지)
* zsh : .zshrc → .config/zsh/{config,variables,functions,aliases}
* bash : .config/bash/.bashrc → .config/bash/{config,bash_variables,bash_functions,bash_aliases}
* secrets : ~/.config/zsh/secrets (미추적, 토큰/키 전용)
* 에디터 : emacs 우선(EDITOR/VISUAL), vim/nano 폴백

## IDE
* emacs : .emacs.d/init.el (주력)
* vim : .vimrc

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
