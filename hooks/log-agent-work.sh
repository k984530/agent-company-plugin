#!/bin/bash
# 에이전트 작업 완료 시 로그 기록 + 결과물 저장
# SubagentStop 이벤트에서 호출됨

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
TEAM=$(echo "$AGENT_NAME" | cut -d'-' -f1)

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

    # 팀별 파일 형식 결정
    case "$TEAM" in
        research|debate|verification|research-verify|debate-verify|marketing-verify)
            # 마크다운 저장
            OUTPUT_FILE="${TEAM_OUTPUT_DIR}/${FILE_TIMESTAMP}_${AGENT_NAME}.md"
            cat > "$OUTPUT_FILE" << MARKDOWN
# ${AGENT_NAME} 작업 결과

**생성일시**: ${TIMESTAMP}
**에이전트**: ${AGENT_NAME}
**팀**: ${TEAM}

---

${RESULT}
MARKDOWN

            # pandoc으로 워드 변환 시도
            if command -v pandoc &> /dev/null; then
                DOCX_FILE="${TEAM_OUTPUT_DIR}/${FILE_TIMESTAMP}_${AGENT_NAME}.docx"
                pandoc "$OUTPUT_FILE" -o "$DOCX_FILE" 2>/dev/null && OUTPUT_FILE="$DOCX_FILE" || true
            fi
            ;;

        marketing)
            # HTML로 저장 (이미지 포함 가능)
            OUTPUT_FILE="${TEAM_OUTPUT_DIR}/${FILE_TIMESTAMP}_${AGENT_NAME}.html"
            cat > "$OUTPUT_FILE" << HTML
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>${AGENT_NAME} 결과물</title>
    <style>
        body { font-family: 'Apple SD Gothic Neo', sans-serif; max-width: 900px; margin: 0 auto; padding: 20px; background: #f5f5f5; }
        .container { background: white; padding: 30px; border-radius: 10px; box-shadow: 0 2px 10px rgba(0,0,0,0.1); }
        .header { border-bottom: 3px solid #007bff; padding-bottom: 15px; margin-bottom: 25px; }
        h1 { color: #333; margin: 0; }
        .meta { color: #666; font-size: 14px; margin-top: 10px; }
        .content { line-height: 1.8; }
        img { max-width: 100%; height: auto; border-radius: 8px; margin: 15px 0; }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h1>📢 ${AGENT_NAME}</h1>
            <p class="meta">생성일시: ${TIMESTAMP}</p>
        </div>
        <div class="content">
${RESULT}
        </div>
    </div>
</body>
</html>
HTML
            ;;

        *)
            OUTPUT_FILE="${TEAM_OUTPUT_DIR}/${FILE_TIMESTAMP}_${AGENT_NAME}.md"
            echo "$RESULT" > "$OUTPUT_FILE"
            ;;
    esac
fi

# 특수문자 이스케이프 (CSV 호환)
REASON_SHORT=$(echo "$REASON" | head -c 200 | tr '\n' ' ' | sed 's/"/""/g')
OUTPUT_FILE_SHORT=$(basename "$OUTPUT_FILE" 2>/dev/null || echo "")

# CSV에 기록
echo "\"$DATE_ONLY\",\"$TIMESTAMP\",\"$AGENT_NAME\",\"$TEAM\",\"completed\",\"$REASON_SHORT\",\"$OUTPUT_FILE_SHORT\"" >> "$CSV_FILE"

# 성공 출력
echo "{\"logged\": true, \"agent\": \"$AGENT_NAME\", \"team\": \"$TEAM\", \"output_file\": \"$OUTPUT_FILE\"}"

exit 0
