#!/bin/bash
# 에이전트 작업 완료 시 로그 기록 + 결과물 저장
# SubagentStop 이벤트에서 호출됨
# 모든 결과물은 .md로 저장 (HR팀 문서변환 에이전트가 워드/엑셀로 변환)

set -euo pipefail

# 프로젝트 디렉토리에 로그 저장 (플러그인을 호출한 프로젝트)
PROJECT_DIR="${CLAUDE_PROJECT_DIR:-$(pwd)}"
LOG_DIR="${PROJECT_DIR}/.agent-company"
CSV_FILE="${LOG_DIR}/agent_work_log.csv"
OUTPUT_BASE="${LOG_DIR}/outputs"

# 디렉토리 생성
mkdir -p "$LOG_DIR"

# stdin에서 JSON 입력 읽기
INPUT=$(cat)

# 에이전트 정보 추출
AGENT_TYPE=$(echo "$INPUT" | jq -r '.subagent_type // "unknown"' 2>/dev/null)
REASON=$(echo "$INPUT" | jq -r '.reason // "completed"' 2>/dev/null)
RESULT=$(echo "$INPUT" | jq -r '.result // ""' 2>/dev/null)

# 에이전트 이름 추출 (agent-company:research-researcher-kang-jihyun -> research-researcher-kang-jihyun)
AGENT_NAME=$(echo "$AGENT_TYPE" | sed 's/.*://')

# 팀 추출 (research-researcher-kang-jihyun -> research)
# verify가 포함된 경우 research-verify 같은 형태로 추출
if echo "$AGENT_NAME" | grep -q "verify"; then
    TEAM=$(echo "$AGENT_NAME" | sed 's/\(.*-verify\).*/\1/')
else
    TEAM=$(echo "$AGENT_NAME" | cut -d'-' -f1)
fi

# 현재 시간
TIMESTAMP=$(date +"%Y-%m-%d %H:%M:%S")
DATE_ONLY=$(date +"%Y-%m-%d")
FILE_TIMESTAMP=$(date +"%Y%m%d_%H%M%S")

# CSV 헤더가 없으면 생성 (UTF-8 BOM 추가)
if [ ! -f "$CSV_FILE" ]; then
    printf '\xEF\xBB\xBF' > "$CSV_FILE"
    echo "날짜,시간,에이전트,팀,상태,작업내용,결과파일" >> "$CSV_FILE"
fi

# 결과물 저장 (결과가 있는 경우)
OUTPUT_FILE=""
if [ -n "$RESULT" ] && [ "$RESULT" != "null" ] && [ ${#RESULT} -gt 50 ]; then
    # 팀별 출력 디렉토리
    TEAM_OUTPUT_DIR="${OUTPUT_BASE}/${TEAM}"
    mkdir -p "$TEAM_OUTPUT_DIR"

    # 모든 팀 결과물을 마크다운으로 저장
    OUTPUT_FILE="${TEAM_OUTPUT_DIR}/${FILE_TIMESTAMP}_${AGENT_NAME}.md"

    # 팀별 이모지 결정
    case "$TEAM" in
        research) EMOJI="🔍" ;;
        debate) EMOJI="💬" ;;
        marketing) EMOJI="📢" ;;
        *verify*) EMOJI="✅" ;;
        hr) EMOJI="👔" ;;
        *) EMOJI="📋" ;;
    esac

    cat > "$OUTPUT_FILE" << MARKDOWN
# ${EMOJI} ${AGENT_NAME} 작업 결과

| 항목 | 내용 |
|------|------|
| **생성일시** | ${TIMESTAMP} |
| **에이전트** | ${AGENT_NAME} |
| **팀** | ${TEAM} |

---

${RESULT}

---

> 📄 이 파일은 자동 생성되었습니다.
> 워드/엑셀 변환이 필요하면 HR팀 문서변환 에이전트(최예진)를 호출하세요.
MARKDOWN
fi

# 특수문자 이스케이프 (CSV 호환)
REASON_SHORT=$(echo "$REASON" | head -c 200 | tr '\n' ' ' | sed 's/"/""/g')
OUTPUT_FILE_SHORT=$(basename "$OUTPUT_FILE" 2>/dev/null || echo "")

# CSV에 기록
echo "\"$DATE_ONLY\",\"$TIMESTAMP\",\"$AGENT_NAME\",\"$TEAM\",\"completed\",\"$REASON_SHORT\",\"$OUTPUT_FILE_SHORT\"" >> "$CSV_FILE"

# 성공 출력
echo "{\"logged\": true, \"agent\": \"$AGENT_NAME\", \"team\": \"$TEAM\", \"output_file\": \"$OUTPUT_FILE\"}"

exit 0
