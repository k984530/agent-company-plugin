#!/bin/bash
# 에이전트 작업 완료 시 로그 기록
# SubagentStop 이벤트에서 호출됨

set -euo pipefail

# 프로젝트 디렉토리에 로그 저장 (플러그인을 호출한 프로젝트)
PROJECT_DIR="${CLAUDE_PROJECT_DIR:-$(pwd)}"
LOG_DIR="${PROJECT_DIR}/.agent-company"
CSV_FILE="${LOG_DIR}/agent_work_log.csv"

# 디렉토리 생성
mkdir -p "$LOG_DIR"

# stdin에서 JSON 입력 읽기
INPUT=$(cat)

# 에이전트 정보 추출
AGENT_TYPE=$(echo "$INPUT" | jq -r '.subagent_type // "unknown"' 2>/dev/null)
REASON=$(echo "$INPUT" | jq -r '.reason // "completed"' 2>/dev/null | head -c 200)

# 에이전트 이름만 추출 (agent-company:research-researcher -> research-researcher)
AGENT_NAME=$(echo "$AGENT_TYPE" | sed 's/.*://')

# 현재 시간
TIMESTAMP=$(date +"%Y-%m-%d %H:%M:%S")
DATE_ONLY=$(date +"%Y-%m-%d")

# CSV 헤더가 없으면 생성 (UTF-8 BOM 추가)
if [ ! -f "$CSV_FILE" ]; then
    printf '\xEF\xBB\xBF' > "$CSV_FILE"
    echo "날짜,시간,에이전트,상태,작업내용" >> "$CSV_FILE"
fi

# 특수문자 이스케이프 (CSV 호환)
REASON_ESCAPED=$(echo "$REASON" | tr '\n' ' ' | sed 's/"/""/g')

# CSV에 기록
echo "\"$DATE_ONLY\",\"$TIMESTAMP\",\"$AGENT_NAME\",\"completed\",\"$REASON_ESCAPED\"" >> "$CSV_FILE"

# 성공 출력
echo "{\"logged\": true, \"agent\": \"$AGENT_NAME\"}"

exit 0
