---
name: agent-company:promote
description: 에이전트의 역할, 권한, 또는 모델을 수정합니다
allowed-tools: Read, Edit, Glob
---

# 📈 에이전트 승진/수정

에이전트의 역할, 도구, 모델 등을 수정합니다.

## 수정 가능한 항목

| 항목 | 설명 | 예시 |
|------|------|------|
| **역할 (description)** | 에이전트의 역할 변경 | "데이터 분석가 → 시니어 데이터 분석가" |
| **도구 (allowed-tools)** | 사용 가능한 도구 추가/제거 | "Write 도구 추가" |
| **모델 (model)** | AI 모델 업그레이드/다운그레이드 | "sonnet → opus" |
| **팀 이동** | 다른 팀으로 이동 | "조사팀 → 토론팀" |

## 모델 업그레이드 경로

```
haiku (기본) → sonnet (분석) → opus (의사결정)
   💰           💰💰           💰💰💰
```

## 실행 지침

1. **에이전트 찾기**: `Glob`으로 대상 에이전트를 찾으세요
   ```
   agents/**/*.md
   ```

2. **현재 상태 확인**: `Read`로 에이전트 파일을 읽어 현재 설정을 확인하세요

3. **변경 사항 파악**: 사용자가 요청한 변경 사항을 파악하세요
   - 도구 추가: `allowed-tools`에 새 도구 추가
   - 도구 제거: `allowed-tools`에서 도구 제거
   - 모델 변경: `model` 필드 수정
   - 역할 변경: `description` 필드 수정
   - 팀 이동: 파일을 새 팀 폴더로 이동

4. **수정 적용**: `Edit` 도구로 에이전트 파일을 수정하세요

5. **결과 보고**: 변경 사항을 요약해서 보고하세요

## 예시

### 도구 추가
사용자: `/promote analyst에게 Write 도구 추가해줘`

```markdown
# Before
allowed-tools: Read, Grep

# After
allowed-tools: Read, Grep, Write
```

### 모델 업그레이드
사용자: `/promote facilitator를 opus로 업그레이드해줘`

```markdown
# Before
model: sonnet

# After
model: opus
```

### 역할 변경
사용자: `/promote researcher를 시니어 리서처로 승진시켜줘`

```markdown
# Before
description: 웹 검색으로 정보를 수집합니다

# After
description: 시니어 리서처 - 웹 검색으로 정보를 수집하고 팀을 리드합니다
```

## 팀 이동 처리

팀 이동이 필요한 경우:
1. 기존 파일의 내용을 읽습니다
2. 새 팀 폴더에 파일을 생성합니다
3. 기존 파일을 삭제합니다
4. 변경 사항을 보고합니다

## 출력 형식

```
📈 에이전트 승진 완료!

[에이전트 이름] 변경 사항:
- [변경 항목]: [이전 값] → [새 값]

현재 설정:
- 팀: [팀 이름]
- 역할: [역할]
- 모델: [모델]
- 도구: [도구 목록]
```
