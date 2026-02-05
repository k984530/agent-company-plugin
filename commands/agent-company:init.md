---
name: agent-company:init
description: 에이전트 회사 초기화 - 프로젝트에 에이전트 목록을 생성합니다
allowed-tools: Write, Bash
---

# 🏢 에이전트 회사 초기화

프로젝트에 에이전트 회사 설정을 초기화합니다.

## 실행 내용

1. `.agent-company/` 디렉토리 생성
2. `roster.json` 에이전트 목록 파일 생성
3. `outputs/` 결과물 저장 폴더 생성

## 초기화 스크립트 실행

다음 Bash 명령을 실행하세요:

```bash
mkdir -p .agent-company/outputs/{research,strategy,marketing,research-verify,strategy-verify,marketing-verify,hr}
```

## roster.json 생성

Write 도구로 다음 파일을 생성하세요:

**파일 경로**: `.agent-company/roster.json`

**내용**:
```json
{
  "version": "1.0.18",
  "initialized_at": "[현재 날짜시간]",
  "teams": {
    "research": {
      "name": "조사팀",
      "emoji": "🔍",
      "members": [
        {"id": "research-researcher-kang-jihyun", "name": "강지현", "role": "연구원"},
        {"id": "research-data-collector-seo-dongwoo", "name": "서동우", "role": "데이터수집"},
        {"id": "research-trend-analyst-shin-yuna", "name": "신유나", "role": "트렌드분석"},
        {"id": "research-benchmarker-oh-jaehyuk", "name": "오재혁", "role": "벤치마커"}
      ]
    },
    "strategy": {
      "name": "전략기획팀",
      "emoji": "📊",
      "members": [
        {"id": "strategy-facilitator-kwon-minseo", "name": "권민서", "role": "퍼실리테이터"},
        {"id": "strategy-analyst-lee-junho", "name": "이준호", "role": "분석가"},
        {"id": "strategy-critic-hong-soyeon", "name": "홍소연", "role": "비평가"},
        {"id": "strategy-synthesizer-bae-sungjin", "name": "배성진", "role": "종합가"}
      ]
    },
    "marketing": {
      "name": "마케팅팀",
      "emoji": "📢",
      "members": [
        {"id": "marketing-content-director-song-hana", "name": "송하나", "role": "콘텐츠디렉터"},
        {"id": "marketing-copywriter-yoo-hyunwoo", "name": "유현우", "role": "카피라이터"},
        {"id": "marketing-visual-designer-jeon-areum", "name": "전아름", "role": "비주얼디자이너"},
        {"id": "marketing-sns-manager-nam-sujin", "name": "남수진", "role": "SNS매니저"}
      ]
    },
    "research-verify": {
      "name": "조사검증팀",
      "emoji": "✅",
      "members": [
        {"id": "research-verify-qa-leader-kim-cheolmin", "name": "김철민", "role": "QA리더"},
        {"id": "research-verify-fact-checker-lee-minjin", "name": "이민진", "role": "팩트체커"},
        {"id": "research-verify-logic-validator-park-seungho", "name": "박승호", "role": "논리검증"}
      ]
    },
    "strategy-verify": {
      "name": "전략검증팀",
      "emoji": "✅",
      "members": [
        {"id": "strategy-verify-qa-leader-choi-seojun", "name": "최서준", "role": "QA리더"},
        {"id": "strategy-verify-fact-checker-jung-haeun", "name": "정하은", "role": "팩트체커"},
        {"id": "strategy-verify-logic-validator-han-jiwoo", "name": "한지우", "role": "논리검증"}
      ]
    },
    "marketing-verify": {
      "name": "마케팅검증팀",
      "emoji": "✅",
      "members": [
        {"id": "marketing-verify-qa-leader-yoon-sohee", "name": "윤소희", "role": "QA리더"},
        {"id": "marketing-verify-fact-checker-jo-minjae", "name": "조민재", "role": "팩트체커"},
        {"id": "marketing-verify-logic-validator-lim-chaewon", "name": "임채원", "role": "논리검증"}
      ]
    },
    "hr": {
      "name": "HR팀",
      "emoji": "👔",
      "members": [
        {"id": "hr-document-converter-choi-yejin", "name": "최예진", "role": "문서변환"}
      ]
    }
  },
  "total_members": 22
}
```

## 완료 메시지

초기화 완료 후 다음을 출력하세요:

```
✅ 에이전트 회사 초기화 완료!

📁 생성된 구조:
.agent-company/
├── roster.json          # 에이전트 목록 (22명)
└── outputs/
    ├── research/        # 조사팀 결과물
    ├── strategy/        # 전략기획팀 결과물
    ├── marketing/       # 마케팅팀 결과물
    ├── research-verify/ # 조사검증팀 결과물
    ├── strategy-verify/ # 전략검증팀 결과물
    ├── marketing-verify/# 마케팅검증팀 결과물
    └── hr/              # HR팀 결과물

🎯 다음 단계:
- /agent-company:roster 로 인원 현황 확인
- /agent-company:meeting 으로 팀 미팅 시작
```
