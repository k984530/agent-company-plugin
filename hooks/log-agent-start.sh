#!/bin/bash
# 에이전트 시작 시 시작 시간을 임시 파일에 저장
# SubagentStart 이벤트 시 호출됨

PLUGIN_ROOT="${CLAUDE_PLUGIN_ROOT:-$(dirname "$0")/..}"
LOG_DIR="${PLUGIN_ROOT}/logs"
TEMP_DIR="${LOG_DIR}/.temp"

# 디렉토리 생성
mkdir -p "$LOG_DIR" "$TEMP_DIR"

# 에이전트 정보
AGENT_NAME="${CLAUDE_SUBAGENT_TYPE:-unknown}"
# agent-company:research/researcher -> researcher
AGENT_SHORT_NAME=$(echo "$AGENT_NAME" | sed 's/.*\///')
START_TIME=$(date +"%Y-%m-%d %H:%M:%S")
START_EPOCH=$(date +%s)

# 시작 시간을 임시 파일에 저장 (종료 시 작업 시간 계산용)
echo "$START_EPOCH" > "$TEMP_DIR/${AGENT_SHORT_NAME}.start"

# stdin에서 JSON 입력 읽기 (prompt 정보 포함)
INPUT=$(cat)
PROMPT=$(echo "$INPUT" | jq -r '.prompt // "N/A"' 2>/dev/null | head -c 100)

# 시작 로그를 임시 파일에 저장
cat > "$TEMP_DIR/${AGENT_SHORT_NAME}.info" << EOF
{
  "agent": "$AGENT_SHORT_NAME",
  "start_time": "$START_TIME",
  "prompt": "$PROMPT"
}
EOF

exit 0
