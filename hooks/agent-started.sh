#!/bin/bash
# 에이전트 시작 시 대시보드에 알림을 전송하는 훅 스크립트
# SubagentStart 이벤트 시 호출됨

DASHBOARD_URL="${AGENT_COMPANY_DASHBOARD_URL:-}"

if [ -z "$DASHBOARD_URL" ]; then
    exit 0
fi

AGENT_NAME="${CLAUDE_SUBAGENT_NAME:-unknown}"
AGENT_TYPE="${CLAUDE_SUBAGENT_TYPE:-general}"
TIMESTAMP=$(date -u +"%Y-%m-%dT%H:%M:%SZ")

PAYLOAD=$(cat <<EOF
{
  "timestamp": "$TIMESTAMP",
  "event": "agent_started",
  "agentName": "$AGENT_NAME",
  "agentType": "$AGENT_TYPE",
  "status": "active"
}
EOF
)

curl -s -X POST "$DASHBOARD_URL" \
    -H "Content-Type: application/json" \
    -d "$PAYLOAD" \
    --max-time 5 \
    > /dev/null 2>&1 || true

exit 0
