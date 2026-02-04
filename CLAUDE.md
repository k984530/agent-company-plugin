# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Claude Code plugin for managing an AI agent company with 4 teams and 15 agents. Users can hire, fire, promote agents and initiate team collaborations using natural language slash commands.

## Architecture

**Plugin Components:**
- `commands/` - Slash commands (roster, hire, fire, promote, meeting)
- `agents/` - Agent definitions (flat structure: `{team}-{agent}.md`)
- `hooks/` - Event handlers for activity logging and dashboard integration
- `logs/` - Auto-generated work logs (agent_work_log.csv)

**Team Structure:**
- Research (4): researcher, data-collector, trend-analyst, benchmarker
- Debate (4): facilitator, analyst, critic, synthesizer
- Verification (3): qa-leader, fact-checker, logic-validator
- Marketing (4): content-director, copywriter, visual-designer, sns-manager

**Collaboration Flow:**
Research → Debate → Verification → Marketing (for full-team tasks)

## Agent File Format

Agents use YAML frontmatter with required fields:
```yaml
---
name: team-agentname
description: Use this agent when... Examples: <example>...</example>
model: opus|sonnet|haiku|inherit
color: cyan|yellow|green|magenta|blue|red
tools: ["Tool1", "Tool2"]
---
[System prompt body]
```

**Critical:** Agent name must match filename (e.g., `research-researcher.md` → `name: research-researcher`)

## Hooks System

`hooks.json` defines event handlers:
- `SubagentStart` → Logs start time to temp file
- `SubagentStop` → Calculates duration, writes to CSV
- `PostToolUse` → Sends activity to dashboard (async)

Work logs saved to `logs/agent_work_log.csv` with: date, agent, start/end time, duration, task content.

## Testing Locally

```bash
# Install plugin locally
claude /install-plugin /path/to/agent-company-plugin

# Test commands
/roster
/meeting 조사팀 AI 트렌드 조사해줘
```

## Environment Variables

- `AGENT_COMPANY_DASHBOARD_URL` - Google Sheets webhook URL for activity dashboard
