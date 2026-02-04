---
name: roster
description: 현재 에이전트 회사의 인원 현황을 보여줍니다
allowed-tools: Read, Glob
---

# 📋 팀 로스터 조회

에이전트 회사의 현재 인원 현황을 표시합니다.

## 조회 옵션

| 명령어 | 설명 |
|--------|------|
| `/roster` | 전체 팀 현황 조회 |
| `/roster 조사팀` | 조사팀(research) 인원만 조회 |
| `/roster 토론팀` | 토론팀(debate) 인원만 조회 |
| `/roster 검증팀` | 검증팀(verification) 인원만 조회 |
| `/roster 마케팅팀` | 마케팅제작팀(marketing) 인원만 조회 |

## 팀 ID 매핑

| 한글 이름 | 영문 ID | 이모지 |
|----------|---------|--------|
| 조사팀 | research | 🔍 |
| 토론팀 | debate | 💬 |
| 검증팀 | verification | ✅ |
| 마케팅팀, 마케팅제작팀 | marketing | 📢 |

## 실행 지침

1. **에이전트 파일 검색**: `Glob`으로 에이전트 파일 목록을 가져옵니다
   - 전체: `agents/**/*.md`
   - 특정 팀: `agents/{team}/*.md`

2. **파일 읽기**: 각 에이전트 파일을 `Read`로 읽어 정보를 추출합니다
   - name (이름)
   - description (역할)
   - model (모델)
   - allowed-tools (도구)

3. **로스터 출력**: 팀별로 정리하여 출력합니다

## 출력 형식

### 전체 조회 시

```
┌─────────────────────────────────────────────────────────────┐
│                    🏢 에이전트 회사 로스터                    │
├─────────────┬─────────────┬─────────────┬─────────────────┤
│  🔍 조사팀   │  💬 토론팀   │  ✅ 검증팀   │  📢 마케팅제작팀 │
├─────────────┼─────────────┼─────────────┼─────────────────┤
│ researcher  │ facilitator │ qa-leader   │ content-director│
│ data-col... │ analyst     │ fact-checker│ copywriter      │
│ trend-an... │ critic      │ logic-val...│ visual-designer │
│ benchmarker │ synthesizer │             │ sns-manager     │
├─────────────┼─────────────┼─────────────┼─────────────────┤
│    4명      │    4명      │    3명      │      4명        │
└─────────────┴─────────────┴─────────────┴─────────────────┘
                         총 인원: 15명
```

### 특정 팀 조회 시

```
🔍 조사팀 (Research Team) 로스터
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

| 이름 | 역할 | 모델 | 도구 |
|------|------|------|------|
| researcher | 웹 검색으로 정보 수집 | sonnet | WebSearch, WebFetch |
| data-collector | 구조화된 데이터 추출 | haiku | mcp__hyperbrowser__*, Grep |
| trend-analyst | 트렌드 분석 및 인사이트 | sonnet | WebSearch, Read |
| benchmarker | 경쟁사/유사 사례 분석 | sonnet | WebSearch, WebFetch |

총 4명
```

## 에러 처리

- 에이전트가 없는 경우: "아직 고용된 에이전트가 없습니다. `/hire`로 새 에이전트를 고용하세요!"
- 존재하지 않는 팀: "해당 팀이 존재하지 않습니다. 사용 가능한 팀: 조사팀, 토론팀, 검증팀, 마케팅팀"
