---
name: roster
description: 현재 에이전트 회사의 인원 현황을 보여줍니다
allowed-tools: Read, Glob
---

# 📋 팀 로스터 조회

에이전트 회사의 현재 인원 현황을 **실제 파일을 읽어서** 동적으로 표시합니다.

## 에이전트 경로
세션 시작 시 `.agent-company/agents` 심볼릭 링크가 자동 생성됩니다.
```
에이전트 경로: .agent-company/agents/
```

## 실행 단계

### 1단계: 에이전트 파일 검색
```
Glob 도구 사용:
- pattern: "*.md"
- path: ".agent-company/agents"
```

**참고**: SessionStart hook이 플러그인의 agents 폴더로 심볼릭 링크를 자동 생성합니다.

### 2단계: 팀별 분류
파일명 패턴으로 팀 구분:
- `research-*.md` (research-verify 제외) → 🔍 조사팀
- `strategy-*.md` (strategy-verify 제외) → 📊 전략기획팀
- `marketing-*.md` (marketing-verify 제외) → 📢 마케팅팀
- `*-verify-*.md` → ✅ 검증팀 (조사/전략/마케팅 각각)
- `hr-*.md` → 👔 HR팀

### 3단계: 각 파일에서 정보 추출
각 .md 파일의 frontmatter에서:
- `name`: 에이전트 ID
- 파일명에서 한글 이름 추출 (예: kang-jihyun → 강지현)

### 4단계: 출력 형식

```
🏢 에이전트 회사 로스터
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

📋 작업팀
┌─────────────────┬─────────────────┬─────────────────┐
│ 🔍 조사팀        │ 📊 전략기획팀    │ 📢 마케팅팀      │
├─────────────────┼─────────────────┼─────────────────┤
│ {동적 목록}      │ {동적 목록}      │ {동적 목록}      │
├─────────────────┼─────────────────┼─────────────────┤
│ {N}명           │ {N}명           │ {N}명           │
└─────────────────┴─────────────────┴─────────────────┘

✅ 검증팀
┌─────────────────┬─────────────────┬─────────────────┐
│ 조사 검증        │ 전략 검증        │ 마케팅 검증      │
├─────────────────┼─────────────────┼─────────────────┤
│ {동적 목록}      │ {동적 목록}      │ {동적 목록}      │
└─────────────────┴─────────────────┴─────────────────┘

👔 HR팀
│ {동적 목록}      │

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
📊 총 인원: {총합}명
```

## 한글 이름 매핑 규칙
파일명의 영문 이름을 한글로 변환:
- kang-jihyun → 강지현
- seo-dongwoo → 서동우
- shin-yuna → 신유나
- oh-jaehyuk → 오재혁
- kwon-minseo → 권민서
- lee-junho → 이준호
- hong-soyeon → 홍소연
- bae-sungjin → 배성진
- song-hana → 송하나
- yoo-hyunwoo → 유현우
- jeon-areum → 전아름
- nam-sujin → 남수진
- kim-cheolmin → 김철민
- lee-minjin → 이민진
- park-seungho → 박승호
- choi-seojun → 최서준
- jung-haeun → 정하은
- han-jiwoo → 한지우
- yoon-sohee → 윤소희
- jo-minjae → 조민재
- lim-chaewon → 임채원
- choi-yejin → 최예진

## 역할 매핑
- researcher → 연구원
- data-collector → 데이터수집
- trend-analyst → 트렌드분석
- benchmarker → 벤치마커
- facilitator → 퍼실리테이터
- analyst → 분석가
- critic → 비평가
- synthesizer → 종합가
- content-director → 콘텐츠디렉터
- copywriter → 카피라이터
- visual-designer → 비주얼디자이너
- sns-manager → SNS매니저
- qa-leader → QA리더
- fact-checker → 팩트체커
- logic-validator → 논리검증
- document-converter → 문서변환

## 중요 지침
1. **반드시 실제 파일을 Glob으로 검색**해서 목록 생성
2. **하드코딩된 목록 사용 금지** - 파일이 없으면 빈 칸 표시
3. 각 팀의 실제 인원수를 카운트해서 표시
4. 파일이 없는 팀은 "(없음)" 표시
