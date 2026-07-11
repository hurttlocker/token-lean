# token-lean

**The decisions-only orchestration discipline for AI agent fleets.**

Not a tool. Not a binary. Not another MCP server. One markdown file your agent reads — and your orchestrator stops burning its context window on work that cheaper contexts should be doing.

Works with any model and any harness: Claude Code, Codex CLI, Cursor, Gemini CLI, opencode, your own agent loop. If it can read markdown, it can run token-lean.

## The problem

If you run agents seriously, your **orchestrator's context window is the most expensive surface in the session** — and the default behavior of every capable model is to fill it with bulk: reading 40 files "to understand," absorbing full test logs, re-sending repo context every turn, polling workers mid-flight. The session gets slower, dumber, and more expensive at the same time, because judgment drowns in pages.

The fix isn't a smarter model. Frontier models make it *worse* — they do scout-work and worker-work inline *because they can*. The fix is a discipline.

## The rule

> **Never generate bulk, never absorb bulk.** Cheaper contexts produce candidates; the orchestrator ratifies, edits, or adjudicates on compact artifacts.

Everything else in the skill derives from that one rule: a delegation ladder (scout → worker → builder → panel), eight concrete practices, and the failure modes to kill on sight.

## The ladder — roles, not model names

| Tier | Role |
|---|---|
| **Scout** | Lookups, directory surveys, git history, log summaries — synthesis in, never file dumps |
| **Worker** | Mechanical edits, well-specced implementation, tests, first-pass reviews |
| **Builder** | Multi-file features, hard debugging, judgment mid-flight |
| **Panel** | Independent proposers + an adjudicator, when one model's answer isn't trustworthy |

Model names rotate monthly; the ladder shape doesn't. Anthropic's Haiku / Sonnet / Opus-and-Fable, OpenAI's GPT-5.6 luna / terra / sol, Google's Flash / Pro, and open-weight equivalents all slot into the same rows — and **effort dials count as rungs**: the same model at low effort and at xhigh are two different tiers. Fill the table once for your stack and follow it.

## The eight practices

1. **Scout before you read** — >3 file reads to answer a question means you should have sent a scout.
2. **1KB hand-backs** — a transcript instead of a report means you briefed it wrong.
3. **One big brief beats twenty steers** — mid-flight steering re-meters your whole window every turn.
4. **Stable prefix, append-only deltas** — prompt caching makes an unchanged prefix ~10x cheaper.
5. **Pre-digest inbound bulk** — with a hard exception for security/auth/schema/payment diffs, which you read raw.
6. **Effort discipline** — effort past sufficiency is spend, not quality.
7. **Verify through agents, report facts** — and never let a builder grade its own work.
8. **Legislate, don't repeat** — the third explanation belongs in a rules file, forever.

Full text with the reasoning behind each: [`skills/token-lean/SKILL.md`](skills/token-lean/SKILL.md).

## Install

**Claude Code — as a skill (30 seconds):**

```bash
mkdir -p ~/.claude/skills/token-lean
curl -fsSL https://raw.githubusercontent.com/hurttlocker/token-lean/main/skills/token-lean/SKILL.md \
  -o ~/.claude/skills/token-lean/SKILL.md
```

Then invoke `/token-lean` at the start of any substantial session, or just say "keep it lean."

**Claude Code — as a plugin (recommended — the ladder comes installed):**

```
/plugin marketplace add hurttlocker/token-lean
/plugin install token-lean@token-lean
```

The plugin ships more than the skill text. You get the ladder as **real dispatchable agents** — `scout` (Haiku, read-only, 1KB-synthesis contract), `worker` (Sonnet, brief-in / report-out), `adjudicator` (panel judge) — plus a **tripwire hook** that nudges the orchestrator after 4 consecutive file reads (practice #1, mechanized instead of honor-system), and a [primitive-by-primitive mapping](skills/token-lean/references/claude-code.md) of every rung and practice to Claude Code's Agent/Workflow machinery. The skill-only install is the discipline; the plugin is the discipline with the equipment already racked.

**Codex CLI:** paste the contents of `skills/token-lean/SKILL.md` (below the frontmatter) into your `AGENTS.md`.

**Cursor:** same content into `.cursorrules` or a project rule.

**Anything else:** it's plain markdown. Put it wherever your agent reads standing instructions.

## Why it works

Two economics, one behavior change. First: delegation moves token burn from your most expensive context to your cheapest — a scout burning 50k tokens to hand back a 1KB synthesis is strictly better than the orchestrator absorbing those 50k tokens itself, because the orchestrator's window is metered on *every subsequent turn*. Second: prompt caching prices an unchanged context prefix at roughly a tenth of a cold read — so a stable, append-only window isn't just tidier, it's compounding savings on every turn of a long session.

The side effect nobody expects: sessions get *smarter*, not just cheaper. An orchestrator that only holds decisions, briefs, and compact reports stays coherent hundreds of turns past the point where a bulk-absorbing session has drowned its own judgment.

## Provenance

This discipline was written by a frontier model — Anthropic's Fable 5 — documenting the shape of its own practice so any orchestrator could run it, then generalized here for every model family: run it on Fable 5, GPT-5.6 sol, Opus, Gemini, Grok, or open-weights — the orchestrator changes, the discipline doesn't. It's the day-to-day operating discipline behind [**o8**](https://o8.run), the governance layer for autonomous engineering teams. token-lean is the efficiency half of running an agent fleet; o8 is the governance half — approvals, audit, and organizational memory across every AI runtime.

## License

MIT — see [LICENSE](LICENSE). Issues and PRs welcome; response not guaranteed (the maintainer's fleet reviews PRs through o8, which is the point).
