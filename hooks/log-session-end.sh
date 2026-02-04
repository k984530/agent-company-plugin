#!/bin/bash
# 세션 종료 시 작업 요약 로그 기록
# SessionEnd 이벤트에서 호출됨

set -euo pipefail

# 프로젝트 디렉토리에 로그 저장
PROJECT_DIR="${CLAUDE_PROJECT_DIR:-$(pwd)}"
LOG_DIR="${PROJECT_DIR}/.agent-company"
CSV_FILE="${LOG_DIR}/session_log.csv"

# 디렉토리 생성
mkdir -p "$LOG_DIR"

# stdin에서 JSON 입력 읽기
INPUT=$(cat)

# 세션 정보 추출
SESSION_ID=$(echo "$INPUT" | jq -r '.session_id // "unknown"' 2>/dev/null)
STOP_REASON=$(echo "$INPUT" | jq -r '.stop_reason // "user_exit"' 2>/dev/null)
TRANSCRIPT_SUMMARY=$(echo "$INPUT" | jq -r '.transcript_summary // ""' 2>/dev/null | head -c 500)

# 현재 시간
TIMESTAMP=$(date +"%Y-%m-%d %H:%M:%S")
DATE_ONLY=$(date +"%Y-%m-%d")

# CSV 헤더가 없으면 생성 (UTF-8 BOM 추가)
if [ ! -f "$CSV_FILE" ]; then
    printf '\xEF\xBB\xBF' > "$CSV_FILE"
    echo "날짜,시간,세션ID,종료사유,작업요약" >> "$CSV_FILE"
fi

# 특수문자 이스케이프 (CSV 호환)
SUMMARY_ESCAPED=$(echo "$TRANSCRIPT_SUMMARY" | tr '\n' ' ' | sed 's/"/""/g')

# CSV에 기록
echo "\"$DATE_ONLY\",\"$TIMESTAMP\",\"$SESSION_ID\",\"$STOP_REASON\",\"$SUMMARY_ESCAPED\"" >> "$CSV_FILE"

# 성공 출력
echo "{\"logged\": true, \"session\": \"$SESSION_ID\"}"

exit 0
