#!/usr/bin/env bash
#
# dotfiles 단위테스트
# ─────────────────────────────────────────────────────────────
# 설정 파일들이 "최소한 깨지지 않았는지" 검증한다:
#   - 셸 스크립트 문법 (bash / zsh / fish)
#   - .gitconfig 파싱 가능 여부
#   - JSON / TOML 유효성
#   - Emacs Lisp 괄호 균형
#
# 도구가 없는 환경에서는 해당 검사를 SKIP 처리하므로
# macOS / Linux / 최소 컨테이너 어디서든 안전하게 실행된다.
# 실패가 하나라도 있으면 종료코드 1.
# ─────────────────────────────────────────────────────────────
set -u

# 리포 루트로 이동 (이 스크립트는 tests/ 안에 있다)
cd "$(dirname "$0")/.." || exit 2

if [ -t 1 ]; then
  C_G=$'\033[32m'; C_R=$'\033[31m'; C_Y=$'\033[33m'; C_B=$'\033[1m'; C_0=$'\033[0m'
else
  C_G=''; C_R=''; C_Y=''; C_B=''; C_0=''
fi

pass=0 fail=0 skip=0

ok()   { pass=$((pass + 1)); printf '  [%sPASS%s] %s\n' "$C_G" "$C_0" "$1"; }
nok()  { fail=$((fail + 1)); printf '  [%sFAIL%s] %s\n' "$C_R" "$C_0" "$1"
         [ -n "${2:-}" ] && printf '%s\n' "$2" | sed 's/^/         /'; return 0; }
skp()  { skip=$((skip + 1)); printf '  [%sSKIP%s] %s\n' "$C_Y" "$C_0" "$1"; }
have() { command -v "$1" >/dev/null 2>&1; }
sec()  { printf '\n%s== %s ==%s\n' "$C_B" "$1" "$C_0"; }

# check <설명> <검사 명령...>  — 명령 성공 시 PASS, 실패 시 FAIL(에러출력 포함)
check() {
  local desc="$1"; shift
  local out
  if out=$("$@" 2>&1); then ok "$desc"; else nok "$desc" "$out"; fi
}

BASH_FILES=".bash_profile .bash_logout .profile \
.config/bash/.bashrc .config/bash/bash_aliases \
.config/bash/bash_functions .config/bash/bash_variables .config/bash/config"

ZSH_FILES=".zshrc .config/zsh/aliases .config/zsh/config \
.config/zsh/functions .config/zsh/variables"

FISH_FILES=".config/fish/config.fish"
JSON_FILES=".claude/settings.json"
TOML_FILES=".codex/config.toml"
ELISP_FILES=".emacs .emacs.d/init.el .emacs.d/cursor-like.el"

sec "셸 문법: bash"
if have bash; then
  for f in $BASH_FILES; do [ -f "$f" ] && check "bash -n $f" bash -n "$f"; done
else skp "bash 미설치"; fi

sec "셸 문법: zsh"
if have zsh; then
  for f in $ZSH_FILES; do [ -f "$f" ] && check "zsh -n $f" zsh -n "$f"; done
else skp "zsh 미설치"; fi

sec "셸 문법: fish"
if have fish; then
  for f in $FISH_FILES; do [ -f "$f" ] && check "fish -n $f" fish -n "$f"; done
else skp "fish 미설치 ($FISH_FILES)"; fi

sec "git 설정 파싱"
if have git; then
  [ -f .gitconfig ] && check ".gitconfig 파싱" git config -f .gitconfig --list
else skp "git 미설치"; fi

sec "JSON 유효성"
if have python3; then
  for f in $JSON_FILES; do
    [ -f "$f" ] && check "JSON $f" python3 -c 'import json,sys; json.load(open(sys.argv[1]))' "$f"
  done
else skp "python3 미설치 (JSON)"; fi

sec "TOML 유효성"
if have python3 && python3 -c 'import tomllib' 2>/dev/null; then
  for f in $TOML_FILES; do
    [ -f "$f" ] && check "TOML $f" python3 -c 'import tomllib,sys; tomllib.load(open(sys.argv[1],"rb"))' "$f"
  done
else skp "python3 tomllib 없음 (TOML, Python 3.11+ 필요)"; fi

sec "Emacs Lisp 괄호 균형"
if have emacs; then
  for f in $ELISP_FILES; do
    [ -f "$f" ] || continue
    check "check-parens $f" emacs -Q --batch --eval \
      "(condition-case e (progn (find-file \"$f\") (check-parens)) (error (princ (error-message-string e)) (kill-emacs 1)))"
  done
else skp "emacs 미설치 (elisp)"; fi

printf '\n%s결과:%s %s%d passed%s, %s%d failed%s, %s%d skipped%s\n' \
  "$C_B" "$C_0" "$C_G" "$pass" "$C_0" "$C_R" "$fail" "$C_0" "$C_Y" "$skip" "$C_0"

[ "$fail" -eq 0 ]
