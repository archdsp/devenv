---
description: 커밋 전 lint → 유닛테스트 → 심층(ultracode) 리뷰 → atomic 커밋 분리 → PR 생성을 한 번에 수행
argument-hint: "[선택 지시: 예) 'PR 생략' / '특정 파일만' / 대상 브랜치]"
allowed-tools: Bash(git add:*), Bash(git status:*), Bash(git diff:*), Bash(git commit:*), Bash(git push:*), Bash(git log:*), Bash(git branch:*), Bash(git switch:*), Bash(git checkout:*), Bash(git rev-parse:*), Bash(gh pr:*), Task
---

# /commit — 안전한 커밋·PR 워크플로

작업 디렉터리의 변경분을 **린트 → 유닛테스트 → 심층 리뷰 → atomic 커밋 → PR** 순서로 처리한다.
`~/.claude/CLAUDE.md`의 전역 규칙(Anaconda 환경, 브랜치 정책, 커밋 메시지 양식)을 함께 지킨다.

추가 지시: $ARGUMENTS

## 0. 사전 점검
- `git status`와 `git diff`(스테이징·언스테이징 모두)로 변경 범위를 파악한다.
- 변경이 없으면 멈추고 그대로 보고한다.
- 현재 브랜치를 확인한다. 전역 규칙상 작업은 `dev`에서 한다. `main` 등 보호 브랜치라면 작업용 브랜치로 분리할 것을 먼저 제안한다.

## 1. Lint / Format (커밋 전 필수)
- 프로젝트에 맞는 린터·포매터를 **자동 감지**해 변경된 파일에만 적용한다:
  - `.pre-commit-config.yaml`이 있으면 `pre-commit run --files <변경파일>`.
  - Python: **활성 conda 환경 안에서** `ruff` / `black` / `flake8` 중 있는 것 (시스템 python 사용 금지).
  - JS/TS: `eslint --fix` + `prettier -w`. Go: `gofmt -w` + `go vet`. Rust: `cargo fmt` + `cargo clippy`. Shell: `shfmt -w` + `shellcheck`.
  - 위에 없으면 레포의 lint 스크립트(`make lint`, `npm run lint`, `tests/run-tests.sh` 등)를 찾아 실행한다.
- 포매터가 파일을 바꾸면 그 결과까지 포함해 다시 본다.
- 린트 에러가 남으면 **커밋을 멈추고** 고친 뒤 재시도한다.

## 2. 유닛테스트 (린트 직후)
- 린트를 통과하면 **커밋 전에 유닛테스트를 돌린다.** 프로젝트의 테스트 러너를 자동 감지해 실행한다:
  - Python: **활성 conda 환경 안에서** `pytest`(또는 `python -m pytest`). JS/TS: `npm test` / `pnpm test` / `yarn test`.
  - Go: `go test ./...`. Rust: `cargo test`. 그 외: `make test`, 레포의 테스트 스크립트(`tests/run-tests.sh` 등).
- 변경 전부터 깨져 있던 기존 실패는 구분해 보고하되, **이번 변경으로 새로 깨진 테스트가 있으면 커밋을 멈추고** 고친 뒤 재시도한다.
- 테스트가 없는 레포면 그 사실을 보고하고 진행한다.

## 3. Ultracode review (심층 리뷰)
- 커밋 전에 변경 diff를 **깊게(ultrathink)** 리뷰한다. 가능하면 전용 리뷰 서브에이전트(`Task`)에 diff를 넘겨 독립적으로 점검한다:
  - 정확성 버그 / 엣지케이스 / 회귀 위험
  - 보안(비밀·키 노출, 인젝션), 에러 처리 누락
  - 단순화·중복 제거·일관성
- 치명적 문제가 있으면 **커밋을 멈추고** 먼저 고친다. 사소한 개선은 적용 여부를 사용자에게 묻는다.

## 4. Atomic 커밋 분리
- 변경을 **논리적으로 독립된 단위**로 나눠 `git add -p` 등으로 부분 스테이징한다.
  - 새 파일은 `git add -p`로 분할되지 않으므로, `git add -N <file>`(intent-to-add) 후 `-p`로 나누거나 한 단위면 통째로 `git add <file>` 한다.
- 한 커밋 = 한 가지 목적. 기능·리팩터·문서·테스트를 한 커밋에 섞지 않는다.
- 각 커밋 메시지는 `~/.gitmessage` 양식을 따른다:
  - 제목 `Type : 한 줄 요약` (Fix / Hack / Refactor / Style / Docs / Test / Chore)
  - 본문 섹션: `Description`, `Fix`/`Refactor`(+/-), `How to test`(테스트 완료 여부·실행 방법 필수), `Reference`(선택)
  - 한글 마크다운, heredoc(`git commit -F`)으로 줄바꿈·서식 유지
  - 마지막 줄: `Co-Authored-By: Claude Opus 4.8 <noreply@anthropic.com>`

## 5. Push & PR
- 작업 브랜치를 `git push -u origin <branch>` (네트워크 실패 시 2/4/8/16초 백오프로 최대 4회 재시도).
- `gh pr create`로 PR 생성: 제목은 대표 변경 요약, 본문은 변경 요약·테스트 방법·리스크를 담는다.
- **단, 추가 지시에 'PR 생략'이 있거나 사용자가 원치 않으면 PR은 만들지 않는다.**
- 보호 브랜치(main 등)에 직접 push 하지 않는다.

## 완료 보고
- 만든 커밋 목록(해시·제목), 린트/리뷰 결과 요약, PR 링크를 보고한다.
