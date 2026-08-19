# Transcript template

File: `interview/<slug>/transcript.md`

Append **immediately after each answer**, before asking the next question. Append only — never rewrite the whole file.

**Language:** write the transcript in the interview language chosen in Step 0. Field names and status values come from the matching column of `terminology.md` — the structure below is identical in both languages, only the wording changes.

---

## File structure

```markdown
# Interview transcript — <problem name>

- Slug: <slug>
- Language: English | Tiếng Việt   ← set in Step 0; never changes mid-interview
- Started: <YYYY-MM-DD>
- Updated: <YYYY-MM-DD>
- Position: Layer <n> (<layer name>) · Q<N>
- Status: IN PROGRESS | SYNTHESIZED

## Problem in the user's own words (verbatim, unedited)

> <paste the original description verbatim>

## Ambiguity Ledger

| # | Ambiguity | Raised at | Status | Note |
|---|---|---|---|---|
| A1 | "VIP customer" has no definition | Q7 | OPEN | |
| A2 | Auto-approval threshold has no number | Q19 | RESOLVED (Q24) | ≥ $2k needs manual approval |
| A3 | Who can reverse a refund decision | Q31 | GENUINELY UNKNOWN | user has never hit this case |

Status uses exactly three values — `OPEN` · `RESOLVED (Q<n>)` · `GENUINELY UNKNOWN`, or in Vietnamese `ĐANG MỞ` · `ĐÃ RÕ (Câu <n>)` · `VÙNG CHƯA BIẾT THẬT`. Item prefix is `A` in English, `M` in Vietnamese.
The interview may not end while any row reads `OPEN`.

## Layer closures

| Layer | Name | Closed at | User confirmed |
|---|---|---|---|
| 0 | Root purpose & definition of success | Q9 | yes |
| 1 | Context & constraints | | |

## Parked ideas

If a solution occurs to you mid-interview, write it here and **say nothing** — voicing it frames the user's thinking. Use it only at synthesis time.

- (Q14) Could split approval into two tiers by order value.

## Q&A log

### Q1 · Layer 0
**Asked:** What's the problem you want me to understand?
**Answered:** <verbatim answer — no summarizing, no paraphrasing>
**Learned:** <1–2 bullets, only what was ACTUALLY said>
**New ambiguities:** A1, A2

### Q2 · Layer 0
...
```

---

## Logging rules

1. **"Answered" is verbatim.** No summarizing, no cleaning up the phrasing, no "tightening". The synthesis has to be able to quote the user exactly.
2. **"Learned" contains only what was said.** If it's your inference, prefix it `[inferred]`.
3. **Every ambiguity gets an A-number.** Numbered items are the only ones that survive the residual sweep.
4. **Update the "Position" line** on every write, so a later session resumes at the right place.
5. **Never delete anything.** If the user changes their mind, log the new answer and mark the old one `[superseded by Q<n>]` — the history of changed minds is itself important evidence.

## Resuming in a new session

1. Read `transcript.md`.
2. Report back to the user: which layer, how many questions asked, how many items still OPEN.
3. Resume from exactly where it stopped, **in the language recorded in the `Language:` field**. **Never re-ask** anything already in the log.
