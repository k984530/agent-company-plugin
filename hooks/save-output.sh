#!/bin/bash
# 팀별 결과물 저장 스크립트
# 사용법: echo "내용" | ./save-output.sh [team] [title]
# team: research, debate, marketing, verification
# 결과물은 {프로젝트}/.agent-company/outputs/{team}/ 에 저장됨

set -euo pipefail

TEAM="${1:-unknown}"
TITLE="${2:-output}"

# 프로젝트 디렉토리
PROJECT_DIR="${CLAUDE_PROJECT_DIR:-$(pwd)}"
OUTPUT_DIR="${PROJECT_DIR}/.agent-company/outputs/${TEAM}"

# 디렉토리 생성
mkdir -p "$OUTPUT_DIR"

# 현재 시간으로 파일명 생성
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
SAFE_TITLE=$(echo "$TITLE" | tr ' ' '_' | tr -cd '[:alnum:]_-')

# stdin에서 내용 읽기
CONTENT=$(cat)

# 팀별 파일 형식 결정
case "$TEAM" in
    research|debate|verification)
        # 마크다운으로 저장 (워드 변환 가능)
        FILENAME="${TIMESTAMP}_${SAFE_TITLE}.md"
        FILEPATH="${OUTPUT_DIR}/${FILENAME}"

        cat > "$FILEPATH" << MARKDOWN
# ${TITLE}

**생성일시**: $(date +"%Y-%m-%d %H:%M:%S")
**팀**: ${TEAM}

---

${CONTENT}
MARKDOWN

        # pandoc이 설치되어 있으면 워드로도 변환
        if command -v pandoc &> /dev/null; then
            DOCX_FILE="${OUTPUT_DIR}/${TIMESTAMP}_${SAFE_TITLE}.docx"
            pandoc "$FILEPATH" -o "$DOCX_FILE" 2>/dev/null || true
            echo "{\"saved\": true, \"markdown\": \"${FILEPATH}\", \"docx\": \"${DOCX_FILE}\"}"
        else
            echo "{\"saved\": true, \"markdown\": \"${FILEPATH}\", \"docx\": null, \"note\": \"pandoc 설치 시 워드 변환 가능\"}"
        fi
        ;;

    marketing)
        # 마케팅은 HTML로 저장 (이미지 포함 가능)
        FILENAME="${TIMESTAMP}_${SAFE_TITLE}.html"
        FILEPATH="${OUTPUT_DIR}/${FILENAME}"

        cat > "$FILEPATH" << HTML
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${TITLE}</title>
    <style>
        body { font-family: 'Apple SD Gothic Neo', sans-serif; max-width: 800px; margin: 0 auto; padding: 20px; }
        .header { border-bottom: 2px solid #333; padding-bottom: 10px; margin-bottom: 20px; }
        .meta { color: #666; font-size: 14px; }
        .content { line-height: 1.8; }
        img { max-width: 100%; height: auto; }
    </style>
</head>
<body>
    <div class="header">
        <h1>${TITLE}</h1>
        <p class="meta">생성일시: $(date +"%Y-%m-%d %H:%M:%S") | 팀: Marketing</p>
    </div>
    <div class="content">
${CONTENT}
    </div>
</body>
</html>
HTML
        echo "{\"saved\": true, \"html\": \"${FILEPATH}\"}"
        ;;

    *)
        FILENAME="${TIMESTAMP}_${SAFE_TITLE}.txt"
        FILEPATH="${OUTPUT_DIR}/${FILENAME}"
        echo "$CONTENT" > "$FILEPATH"
        echo "{\"saved\": true, \"file\": \"${FILEPATH}\"}"
        ;;
esac

exit 0
