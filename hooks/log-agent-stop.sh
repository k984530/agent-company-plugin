#!/bin/bash
# 에이전트 종료 시 작업 기록을 CSV 파일에 저장
# SubagentStop 이벤트 시 호출됨

PLUGIN_ROOT="${CLAUDE_PLUGIN_ROOT:-$(dirname "$0")/..}"
LOG_DIR="${PLUGIN_ROOT}/logs"
TEMP_DIR="${LOG_DIR}/.temp"
CSV_FILE="${LOG_DIR}/agent_work_log.csv"

# 디렉토리 생성
mkdir -p "$LOG_DIR" "$TEMP_DIR"

# 에이전트 정보
AGENT_NAME="${CLAUDE_SUBAGENT_TYPE:-unknown}"
AGENT_SHORT_NAME=$(echo "$AGENT_NAME" | sed 's/.*\///')
END_TIME=$(date +"%Y-%m-%d %H:%M:%S")
END_EPOCH=$(date +%s)

# CSV 헤더가 없으면 생성 (Excel에서 열 때 UTF-8 BOM 추가)
if [ ! -f "$CSV_FILE" ]; then
    # UTF-8 BOM 추가 (Excel 한글 호환)
    printf '\xEF\xBB\xBF' > "$CSV_FILE"
    echo "날짜,에이전트,시작시간,종료시간,작업시간(초),작업시간,작업내용" >> "$CSV_FILE"
fi

# 시작 시간 읽기
START_EPOCH_FILE="$TEMP_DIR/${AGENT_SHORT_NAME}.start"
INFO_FILE="$TEMP_DIR/${AGENT_SHORT_NAME}.info"

if [ -f "$START_EPOCH_FILE" ]; then
    START_EPOCH=$(cat "$START_EPOCH_FILE")
    DURATION_SEC=$((END_EPOCH - START_EPOCH))

    # 작업 시간 포맷 (분:초)
    DURATION_MIN=$((DURATION_SEC / 60))
    DURATION_SEC_REMAIN=$((DURATION_SEC % 60))
    DURATION_FORMAT="${DURATION_MIN}분 ${DURATION_SEC_REMAIN}초"
else
    DURATION_SEC=0
    DURATION_FORMAT="N/A"
fi

# 시작 정보 읽기
if [ -f "$INFO_FILE" ]; then
    START_TIME=$(jq -r '.start_time // "N/A"' "$INFO_FILE" 2>/dev/null)
    PROMPT=$(jq -r '.prompt // "N/A"' "$INFO_FILE" 2>/dev/null)
else
    START_TIME="N/A"
    PROMPT="N/A"
fi

# 날짜만 추출
DATE_ONLY=$(date +"%Y-%m-%d")

# 작업 내용에서 특수문자 이스케이프 (CSV 호환)
PROMPT_ESCAPED=$(echo "$PROMPT" | tr '\n' ' ' | sed 's/"/""/g')

# CSV에 기록
echo "\"$DATE_ONLY\",\"$AGENT_SHORT_NAME\",\"$START_TIME\",\"$END_TIME\",$DURATION_SEC,\"$DURATION_FORMAT\",\"$PROMPT_ESCAPED\"" >> "$CSV_FILE"

# 임시 파일 정리
rm -f "$START_EPOCH_FILE" "$INFO_FILE"

exit 0
