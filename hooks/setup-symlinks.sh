#!/bin/bash
# 세션 시작 시 심볼릭 링크 생성
# SessionStart 이벤트에서 호출됨

set -euo pipefail

# 플러그인 루트 경로
PLUGIN_ROOT="${CLAUDE_PLUGIN_ROOT:-$(dirname "$(dirname "$0")")}"

# 프로젝트 디렉토리
PROJECT_DIR="${CLAUDE_PROJECT_DIR:-$(pwd)}"

# .agent-company 디렉토리 생성
AGENT_COMPANY_DIR="${PROJECT_DIR}/.agent-company"
mkdir -p "$AGENT_COMPANY_DIR"

# 심볼릭 링크 생성 (agents 폴더)
LINK_PATH="${AGENT_COMPANY_DIR}/agents"
TARGET_PATH="${PLUGIN_ROOT}/agents"

# 기존 링크가 있으면 삭제 후 재생성
if [ -L "$LINK_PATH" ]; then
    rm "$LINK_PATH"
fi

# 심볼릭 링크 생성
if [ -d "$TARGET_PATH" ]; then
    ln -s "$TARGET_PATH" "$LINK_PATH" 2>/dev/null || true
    echo "{\"symlink_created\": true, \"path\": \"$LINK_PATH\"}"
else
    echo "{\"symlink_created\": false, \"error\": \"agents folder not found\"}"
fi

exit 0
