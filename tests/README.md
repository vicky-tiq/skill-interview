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

## This suite is flaky by nature — read this before trusting a red

The thing under test is a language model, so a single turn's wording is not deterministic.
Across four consecutive runs on identical code the suite scored 15–17 of 17, failing a
*different* assertion nearly every time: T2b, then T3b, then T5a, then T2b and T6a. That
pattern is the signature of non-determinism, not of a regression — a real regression fails
the same assertion every run.

Two causes were found and fixed, and one remains:

1. **Fixed — shared working directory.** Every test wrote its interview into one `$WORK`,
   so a transcript from one test was found by the next. The skill correctly flagged the
   foreign content as something the user never said and voided it, which failed whichever
   assertion happened to depend on it. Each test now gets its own directory.
2. **Fixed — negation-blind grep.** T5a matched `tự quyết` anywhere, so "tôi sẽ **không**
   tự quyết thay bạn" — the rule being obeyed — was scored as the rule being broken.
   Negated matches are now stripped before the check.
3. **Remaining — turn-level assertions on model output.** T2b and T6a still flake: a turn
   sometimes announces what it is about to do without asking in the same message, and the
   quote-back sometimes paraphrases the number instead of reproducing it.

**How to read a run:** a single red on a different assertion each time is noise. The same
assertion red on consecutive runs is a defect. Before concluding anything, run it twice.

If this suite needs to gate anything, run each assertion three times and take the majority
— roughly triple the cost and the only honest way to gate on a stochastic system.

## Why two assertions are ranges, not equalities

Rules 6 and 7 mean some turns legitimately do not advance the interview. A doubled reply
is voided and re-asked; a rung of the reformulation climb parks what the user said instead
of logging a Q&A block. Assertions that demand *every* turn ask exactly one question and
append to the transcript were measuring determinism the skill does not promise — and they
failed on different runs for different reasons, which is the signature of a bad test
rather than a regression.

- **T2b** accepts 1–2 question marks. `?` is a crude proxy for question count: one question
  can carry a second mark when the turn quotes something back. What must never happen is 0
  (the turn asked nothing and the interview stalled) or 3+ (it bundled). Strict
  exactly-one checks remain in T2d and T6c, which run on cleaner fixtures.
- **T3b** allows up to three answering turns. What it asserts is that logging is not
  batched to the end, which is the actual rule — not that every individual turn appends.

If you tighten these back up, expect intermittent red on green code.

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
