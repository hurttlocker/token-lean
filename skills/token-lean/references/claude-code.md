# Running token-lean on Claude Code — exact primitives

The ladder and the eight practices map onto native Claude Code machinery. This file is the lookup table; read it once, then just use the calls.

## The ladder → tool calls

| Rung | Claude Code primitive |
|---|---|
| **Scout** | `Agent` tool with `subagent_type: "Explore"` (built-in, read-only), or this plugin's `scout` agent (Haiku, synthesis-only report contract). For one-off cheapness on any agent: `model: "haiku"`. |
| **Worker** | This plugin's `worker` agent (Sonnet, brief-in / report-out), or `subagent_type: "general-purpose"` with `model: "sonnet"`. |
| **Builder** | `general-purpose` agent with the model omitted — it inherits the session's frontier model. Give it the senior-colleague brief; run it in the background and wait for the report. |
| **Panel** | The `Workflow` tool: fan out 2–3 proposer `agent()` calls in `parallel()` (proposers never see each other's drafts), then close with this plugin's `adjudicator` agent. Requires the user's opt-in for multi-agent orchestration. |

**Effort dials as rungs:** the `Agent` tool and Workflow `agent()` calls accept an effort override (`'low' | 'medium' | 'high' | 'xhigh' | 'max'`). A frontier model at `low` is often your best scout; reserve `xhigh`/`max` for single decisions that demand them.

## The practices → mechanics

- **Scout before you read (#1):** the plugin ships a tripwire — a `PostToolUse` hook that counts consecutive `Read` calls and nudges after 4 in a row. The nudge is advisory; reads for files you're actively editing are exempt by its own wording.
- **1KB hand-backs (#2):** the shipped `scout`/`worker` agents carry the report contract in their system prompts, so you don't restate it per dispatch. For structured hand-backs in workflows, use `agent(prompt, {schema})` — validation happens at the tool layer.
- **One big brief (#3):** background agents (`run_in_background`, the default) make polling worthless anyway — the harness notifies you on completion. Continue a prior agent with `SendMessage` instead of re-briefing a fresh one.
- **Stable prefix (#4):** don't churn CLAUDE.md or early-session context mid-task; the prompt cache TTL is ~5 minutes, so batch your delegations rather than trickling them across cache-cold gaps.
- **Pre-digest inbound bulk (#5):** pipe logs/test output to a `scout` and read its digest. The exception stands: security/auth/schema/payment diffs get read raw, in your own window.
- **Verify through agents (#7):** send an independent reviewer told to refute — never the builder that wrote it. On Claude Code that's one `Agent` call with a "try to refute this" brief, or an adversarial-verify stage in a Workflow.
- **Legislate, don't repeat (#8):** the third explanation goes in CLAUDE.md, a skill, or an agent definition under `.claude/agents/` — agent definitions are exactly "rules written once" for a whole class of dispatches.
