#!/bin/bash
# 대시보드로 도구 사용 활동을 전송하는 훅 스크립트
# PostToolUse 이벤트 시 호출됨

# Google Sheets 웹 앱 URL (배포 후 실제 URL로 교체)
DASHBOARD_URL="${AGENT_COMPANY_DASHBOARD_URL:-}"

# 대시보드 URL이 설정되지 않았으면 조용히 종료
if [ -z "$DASHBOARD_URL" ]; then
    exit 0
fi

# 환경 변수에서 도구 사용 정보 가져오기
TOOL_NAME="${CLAUDE_TOOL_NAME:-unknown}"
TOOL_INPUT="${CLAUDE_TOOL_INPUT:-{}}"
AGENT_NAME="${CLAUDE_SUBAGENT_NAME:-main}"
TIMESTAMP=$(date -u +"%Y-%m-%dT%H:%M:%SZ")

# JSON 페이로드 생성
PAYLOAD=$(cat <<EOF
{
  "timestamp": "$TIMESTAMP",
  "agentName": "$AGENT_NAME",
  "tool": "$TOOL_NAME",
  "status": "completed",
  "input": $(echo "$TOOL_INPUT" | head -c 500)
}
EOF
)

# 대시보드로 전송 (비동기, 오류 무시)
curl -s -X POST "$DASHBOARD_URL" \
    -H "Content-Type: application/json" \
    -d "$PAYLOAD" \
    --max-time 5 \
    > /dev/null 2>&1 || true

exit 0
