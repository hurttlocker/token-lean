# Running token-lean on Codex CLI — exact primitives

The ladder and the eight practices map onto Codex profiles and independent `codex exec` runs. This file is the lookup table; read it once, then use the calls.

## Install the equipment

Codex 0.134 and later loads each profile from `$CODEX_HOME/<name>.config.toml`. Inline `[profiles.<name>]` blocks in `config.toml` are legacy and no longer resolve.

```bash
mkdir -p ~/.agents/skills/token-lean ~/.codex
cp -R skills/token-lean/. ~/.agents/skills/token-lean/
cp codex/profiles/*.config.toml ~/.codex/
```

Restart Codex after installing the skill. Invoke it with `$token-lean` or select it through `/skills`; Codex loads the full discipline only when invoked. Custom prompts under `~/.codex/prompts` are deprecated, so this equipment uses the supported skill successor.

## The ladder → profile dispatch

| Rung | Codex CLI primitive |
|---|---|
| **Scout** | [`scout.config.toml`](../../../codex/profiles/scout.config.toml): GPT-5.6 Luna at `low`, read-only. Dispatch with `codex exec -p scout "..."`. |
| **Worker** | [`worker.config.toml`](../../../codex/profiles/worker.config.toml): GPT-5.6 Terra at `medium`, workspace-write. Dispatch with `codex exec -p worker "..."`. |
| **Builder** | [`builder.config.toml`](../../../codex/profiles/builder.config.toml): GPT-5.6 Sol at `high`, workspace-write. Dispatch with `codex exec -p builder "..."`. |
| **Panel** | Run N fresh `codex exec` proposers, each with the same brief and no shared session, then give only their reports to one builder-profile adjudicator. |

Profiles use top-level `model` and `model_reasoning_effort` keys. The shipped low → medium → high settings make effort part of the ladder; use a one-off `-c model_reasoning_effort='"xhigh"'` only for a decision that warrants another rung.

## Panel — isolated proposers, one adjudicator

Each `codex exec` call starts a separate session. `--ephemeral` also keeps proposer runs out of saved session history.

```bash
mkdir -p .token-lean-panel
brief='Choose a migration plan. Return one proposal under 1KB with risks and verification.'

codex exec -p builder --ephemeral "$brief" > .token-lean-panel/a.md &
codex exec -p builder --ephemeral "$brief" > .token-lean-panel/b.md &
codex exec -p builder --ephemeral "$brief" > .token-lean-panel/c.md &
wait

codex exec -p builder --ephemeral \
  "Adjudicate .token-lean-panel/a.md, b.md, and c.md. Attack each first, then return the synthesized verdict, ranking, and shared blind spots under 1KB."
```

Never resume or fork a proposer into another proposer. Independence is the point.

## The practices → mechanics

- **Scout before you read (#1):** dispatch `codex exec -p scout` before the orchestrator reads more than about three files for an answer.
- **1KB hand-backs (#2):** end every exec brief with `Final output: compact report under 1KB; answer, 2–5 file:line pointers, caveats only.` The final stdout is the hand-back; do not return a transcript.
- **One big brief (#3):** put context, constraints, file pointers, acceptance criteria, verification, and report format in the first `codex exec` prompt. Start a new run only for a new unit of work.
- **Stable prefix (#4):** keep legislated project rules in `AGENTS.md`; do not churn that stable layer mid-task. Append task-specific deltas in the exec brief.
- **Pre-digest inbound bulk (#5):** pipe bulk through the scout profile: `make test 2>&1 | codex exec -p scout "Digest stdin under 1KB: failures, likely cause, next check."`. Read security/auth/schema/payment diffs raw.
- **Effort discipline (#6):** use the profile rung that clears the bar. Override effort for one run rather than raising a permanent default.
- **Verify through agents (#7):** run an independent `codex exec -p worker` reviewer told to refute the builder and include the actual verification tail.
- **Legislate, don't repeat (#8):** the third repeated instruction belongs in `AGENTS.md` or a Codex skill.

Schema and model IDs were checked against the current [profile documentation](https://developers.openai.com/codex/config-advanced#profiles), [configuration reference](https://developers.openai.com/codex/config-reference), [skills documentation](https://developers.openai.com/codex/skills), and GPT-5.6 model pages for [Luna](https://developers.openai.com/api/docs/models/gpt-5.6-luna), [Terra](https://developers.openai.com/api/docs/models/gpt-5.6-terra), and [Sol](https://developers.openai.com/api/docs/models/gpt-5.6-sol).
