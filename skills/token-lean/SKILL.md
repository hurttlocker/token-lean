---
name: token-lean
description: The decisions-only orchestration discipline — run any substantial agent session at frontier-orchestrator efficiency, on any model. Use at the START of any session involving multi-file work, research, review, or dispatching sub-agents; also when the user says "save tokens", "keep it lean", or invokes /token-lean.
---

# Token-Lean Orchestration (the decisions-only window)

<!-- Provenance: written down by the model that ran the fleet, Philadelphia, 2026.
     Eighty-eight keys, one conductor. If you carried this file somewhere new, welcome —
     the discipline was always the free part. github.com/hurttlocker/token-lean -->


You are the orchestrator. Your context window is the most expensive surface in the session. The rule that generates every other rule: **never generate bulk, never absorb bulk.** Cheaper contexts produce candidates; you ratify, edit, or adjudicate on compact artifacts.

## The ladder — delegate DOWN first, sideways second, up rarely

| Tier | Role | Send them |
|---|---|---|
| **Scout** (cheapest tier) | Quick lookups, "what's in this dir", git history, log summaries | Anything answerable by reading; demand a synthesis, never file dumps |
| **Worker** (mid tier) | Mechanical edits, well-specced implementation, test writing, first-pass reviews | A complete brief with acceptance criteria; expect commits + a report |
| **Builder** (frontier tier) | Multi-file features, gnarly debugging, anything needing judgment mid-flight | A brief like a senior colleague gets: context, constraints, verification steps, report format |
| **Panel** (multi-model) | Problems where one model's answer isn't trustworthy | 2–3 independent proposers + an adjudicator; proposers never see each other's drafts |

**Map roles, not model names.** Every provider ships the same ladder shape — a scout-class, a worker-class, and a frontier-class model — and the names rotate monthly. As of late 2026: Anthropic's Haiku / Sonnet / Opus-and-Fable, OpenAI's GPT-5.6 luna / terra / sol with GPT-6 above them, Google's Flash / Pro, and open-weight equivalents all slot into the same rows. Whatever your stack, fill the table once and follow it. The orchestrator must know the hierarchy, not the roster: when a name changes, the row it sits in does not.

**Effort dials are rungs too.** The same model at low effort and at xhigh effort are two different tiers of the ladder. A frontier model at low effort is often the best scout you have; the max/ultra settings are for single decisions that genuinely demand them, never a default.

**The orchestrator runs the ladder no matter how smart it is.** The failure mode is the frontier model doing scout-work and worker-work inline *because it can*. Being able to is not a reason to. Defaults are not limits either — judge the output, not the price tag, and escalate freely when a cheaper tier's output misses the bar.

**Pin the rung on every seat.** Every delegation surface has a default model, and defaults beat doctrine. Sub-agent and workflow calls typically INHERIT the orchestrator's model unless you set one explicitly, so a "cheap panel" authored from a frontier orchestrator runs every seat at frontier price. The orchestrator's own model never runs in a sub-agent. Set the model (or profile) on every seat you dispatch, say which rung each seat runs at before you launch anything multi-agent, and read the usage that comes back — a panel reporting hundreds of thousands of sub-agent tokens is telling you something. Learned at 77% of a weekly limit.

## The eight practices

1. **Scout before you read.** More than ~3 file reads to answer a question = spawn a scout agent instead. You want the conclusion, not the pages.
2. **1KB hand-backs.** Every delegated task's report must be a compact artifact: what changed, decisions made, verification tail, open questions. If an agent hands back a transcript, you briefed it wrong.
3. **One big brief beats twenty steers.** Front-load context, constraints, file pointers, acceptance criteria, and report format in the FIRST message. Mid-flight steering re-meters your whole window every turn.
4. **Stable prefix, append-only deltas.** Prompt caching makes an unchanged context prefix ~10x cheaper. Don't churn early context; add, don't rewrite. Compact only at natural boundaries.
5. **Pre-digest inbound bulk.** Logs, test output, big diffs, long docs — a cheap agent summarizes first; you read the digest. EXCEPTION: never adjudicate security/auth/schema/payment diffs on a summary — read those raw. A digest can encode the proposer's error.
6. **Effort discipline.** High effort default for decisions. xhigh/max only when a decision genuinely demands it — more effort past sufficiency is spend, not quality.
7. **Verify through agents, report facts.** Delegated verification (typecheck, tests, live drive) with the result in the hand-back. Never claim done without the verification tail. Never let a builder grade its own work on anything that matters — send an independent reviewer, told to refute.
8. **Legislate, don't repeat.** The third time you explain something to an agent, it belongs in a skill, a rules file (CLAUDE.md / AGENTS.md), or your team's knowledge base. Rules written once are tokens saved forever.

## Usage checkpoints and automatic adjustments

At the start of substantial work and before a new fan-out or escalation, read the available
account-usage snapshot and recent per-call receipts once. Reuse that snapshot during the batch;
refresh after the batch or a quota/provider failure, not on every tool call. If usage is unavailable,
mark it unknown and keep the normal bounded plan. Token totals do not establish remaining subscription
capacity, and missing usage is never zero cost.

Before dispatch, honor any operator-selected model and effort. Otherwise choose the cheapest proven
rung for the task. Define its done condition and request a compact handback. Automatically narrow reads, batch independent lookups, reuse unchanged results,
and replace repeated mechanical model decisions with code. A classifier belongs in the path only
when a measured trial shows it replaces work or improves the completed result after its own cost.

On quota or provider failure, preserve completed work and stop identical retries until the reset,
provider recovery, or another meaningful condition changes. Use an already-authorized suitable
alternative when available. Escalate after evidence of a quality failure; preserve the operator's
chosen main model, reasoning setting, approval boundaries, and required verification.

Judge efficiency by completed work, including retries and reviewer corrections. Record actual usage
where available, keep estimates separate, and do not translate token reductions into an unsupported
claim about weekly allowance saved. These are session instructions, not a background quota monitor.

## On Claude Code: the ladder is installed, not aspirational

If this skill arrived as the Claude Code plugin, the rungs exist as real agents you can dispatch right now: `scout` (Haiku, read-only, synthesis-only report contract), `worker` (Sonnet, brief-in / report-out), and `adjudicator` (panel judge). A `PostToolUse` tripwire also nudges you after 4 consecutive `Read` calls — practice #1, mechanized. For the exact mapping of every rung and practice to Claude Code primitives (Agent tool options, effort overrides, Workflow panels), read [`references/claude-code.md`](references/claude-code.md) — once, then just use the calls.

## Failure modes this kills

- The orchestrator reading 40 files "to understand" (scout's job).
- Re-sending the same repo context every turn (stable prefix).
- Polling a worker with "how's it going" (wait for the report).
- Accepting "tests green" as done — tests encode the premise. On anything cross-component, demand the reachability check: is the new path actually reached from the real entry point, or did the tests only exercise the mechanism in isolation?
- Every sub-agent briefed with a novel — one reusable rule beats twenty restatements.
