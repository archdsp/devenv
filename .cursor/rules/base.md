# Rule: Engineering Discipline (Architecture + Performance + Math)

## Purpose
아키텍처 일관성, 코드 품질, 하드웨어 성능, 수학적 정당성을 동시에 확보

## Scope
전체 코드베이스 (Python, C++, C)

---

## 1. Architecture & Design

### Rules
- Layered 또는 Clean Architecture 유지
- business logic은 service/domain layer에만 존재
- I/O 및 HW 접근은 adapter/driver layer로 분리
- dependency direction은 inward 유지
- interface 기반 설계 (Python ABC, C++ virtual)

### Design Pattern
- Factory: 객체 생성 분리
- Strategy: 알고리즘 교체 가능
- Adapter: HW abstraction
- Singleton: 제한적으로만 사용

### Anti-patterns
- controller에서 직접 HW/DB 접근
- global state 남용
- circular dependency

---

## 2. Code Quality

### Rules
- 함수는 single responsibility
- 함수 길이 ≤ 50 lines
- side-effect 최소화
- deterministic output 유지
- 명시적 error handling

### Anti-patterns
- silent fail
- magic number
- hidden state

---

## 3. Python Performance

### Rules
- type hint 필수
- vectorization 우선 (numpy, torch)
- loop 최소화
- profiling 기반 최적화

### Performance
- O(N^2) 이상 알고리즘 금지 (근거 없으면)
- memory copy 최소화

### Anti-patterns
- python loop heavy computation
- deepcopy 남용

---

## 4. C/C++ Hardware-aware

### Rules
- memory layout 명시적 설계
- cache locality 고려
- heap allocation 최소화
- const correctness 유지
- RAII 적용 (C++)

### Performance
- SIMD 활용 고려
- alignment 고려
- branch prediction 고려

### Anti-patterns
- virtual call in hot path
- fragmented memory

---

## 5. Edge & HW Optimization

### Rules
- latency, throughput 반드시 측정
- zero-copy 우선
- batch processing 고려
- async pipeline 설계

### Anti-patterns
- blocking pipeline
- unnecessary memcpy
- frame-by-frame naive 처리

---

## 6. Mathematical Rigor

### Rules
- 시간복잡도 명시 (Big-O)
- approximation 시 error bound 명시
- heuristic 사용 시 근거 필수
- numerical stability 고려

### Anti-patterns
- 근거 없는 threshold
- empirical tuning만 존재

---

## 7. AI Assistant Behavior

### Rules
- 실행 가능한 코드만 생성
- 기존 코드 스타일 유지
- 변경 범위 최소화
- 설명 최소화, 코드 중심

### Anti-patterns
- pseudo code
- TODO 포함 코드
- 과도한 리팩토링

---

## Notes
- 구조 > 성능 > 미세 최적화
- 성능은 측정 기반으로 판단
- 설명 불가능한 알고리즘은 사용 금지
