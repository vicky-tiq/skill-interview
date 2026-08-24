# tests

Headless smoke tests for the `interview` skill, driven through `claude -p`.

```bash
tests/run-tests.sh            # test the published plugin from GitHub
tests/run-tests.sh --local    # test the working tree instead
tests/run-tests.sh --keep     # keep the sandbox dir for inspection
```

Each run costs ~5 API turns and takes a few minutes. Everything happens in a
`mktemp -d` sandbox: the interview's own output files land there, not in your repo.

## What is covered

| Test | Asserts | Why it matters |
|---|---|---|
| T1 | First reply offers English / Tiếng Việt | Step 0 must precede every content question |
| T2a | Turn 1 carries one question (bilingual, so 1–2 `?`) | Rule 1 |
| T1c | No "cannot read references/" complaint | Without the banks the skill runs on ~280 fewer seed questions |
| T2b | Turn 2 carries exactly one `?` | Rule 1, now monolingual so the count is exact |
| T3a | `transcript.md` exists mid-interview | Rule 5 — logging is per-answer, not batched |
| T3b | It grew after the next answer | Rule 5, the part that actually breaks |
| T4a | A fresh session reports its position | Resume works at all |
| T4b | It does not re-ask the opening question | Resume works *correctly* |

## What is NOT covered

- **The whole-picture checkpoint** (after Layer 5) needs ~35 turns to reach. Too
  expensive for a smoke test; verify it by hand.
- **The synthesis HTML** — same reason, it only appears at the end.
- **`AskUserQuestion`** is disabled, because a headless run cannot answer it. The
  skill falls back to plain-text questions and the assertions read those. The
  multiple-choice path is therefore untested here.
- **A genuinely installed plugin at runtime.** Install is verified for real
  (`marketplace add` + `install` into an isolated `CLAUDE_CONFIG_DIR`), but the
  interview turns then run via `--plugin-dir` against the installed copy, because
  `claude -p` authenticates from the real config and an isolated one returns
  nothing. Same files, one less layer of fidelity.

## CLI traps this script already works around

Each of these silently produced *wrong test results* rather than an error, so they
are worth knowing before you extend the suite:

1. **`--disallowedTools` is variadic** and swallows anything after it, including the
   prompt. Put the prompt first and this flag last. Otherwise `claude` exits with
   "Input must be provided" and every assertion reads an empty string — which looked
   like six skill failures.
2. **`CLAUDE_CONFIG_DIR` breaks `claude -p` auth.** Use it for plugin install checks
   only, never for the interview turns.
3. **A fixed `--session-id` resumes the previous run.** Turn 1 then continues an old
   conversation and the language question never appears. Generate a fresh UUID per run.
4. **An empty reply must fail, not pass.** A `grep -v`-style assertion trivially
   passes on empty input. `sane()` guards every block for this reason.
5. **`</dev/null`** avoids a 3-second stdin wait on every single turn.

When `claude plugin eval` leaves early access, these cases should move to
`evals/**/case.yaml` with LLM graders, which will judge question quality rather
than just counting question marks.
