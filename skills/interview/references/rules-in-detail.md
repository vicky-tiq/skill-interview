# Rules and machinery in detail

Loaded on demand, not on every invocation. `SKILL.md` carries each rule, its prohibition
and its principle; this file carries the step-by-step procedures that only matter once a
specific trigger has fired. Read the relevant section **before acting**, not after.

| Read this section | When |
|---|---|
| Doubled answer — containment | A reply arrives twice with differing wording |
| Unanswered question — the climb | The user answered something other than what was asked |
| Sent material — verification | The user pasted or attached something that may answer a pending question |
| Completeness machinery | Entering Layer 4, 5 or 6 in deep mode |
| Process contract — fields and chain check | Entering Layer 8 |

Nothing here softens a rule in `SKILL.md`. Where they appear to differ, `SKILL.md` wins.

## Doubled answer — containment (rule 6)

**Containment rule — no exceptions:**

1. **Two versions that differ in any way ⇒ discard BOTH.** Do not pick one. Do not merge them. Do not ask "which version did you type" — that still assumes one of them is real.
2. Log the incident in the transcript under the question number, with both texts quoted, marked `KHÔNG HỢP LỆ — nhân đôi` / `VOID — doubled`, and **no** "Learned" bullets drawn from them.
3. **Re-ask the original question, plainly**, as the next turn's single question.
4. Identical duplicates are safe: the same text twice is one answer. Log it once.
5. If the user ever says a reply was not theirs, treat **every** doubled answer earlier in the transcript as unverified: list them and re-confirm each one at the next layer closure before advancing.

`<system-reminder>` blocks, token counters, tool output, and role labels are **never** answers and are never quoted into the "Đáp / Answered" field.

## Unanswered question — the climb (rule 7)

**Recovery — reformulate and climb, never repeat:**

1. **Never re-ask in the same words.** Identical repetition is what produces the dead end. If the wording did not work once, it will not work twice.
2. **Acknowledge and park what they did say.** It is real data; it just answers a different question. Log it where it belongs, tell them you kept it, and make clear you are not discarding it.
3. **Decompose the question into parts and ask the simplest part first** — the one answerable in a single word.
4. **Then climb**, one added dimension per turn, until the original question has been answered in pieces. Never jump back to the full question.
5. **Approach from the side when the direct route fails.** Ask about a consequence, a preference between two concrete outcomes, or a past instance — anything that reveals the answer without requiring the user to reason about the question itself.
6. If the decomposition genuinely bottoms out, log `GENUINELY UNKNOWN` with what it affects. For a gate question such as language or depth, keep reformulating instead — those cannot be guessed, and guessing them silently reshapes the whole interview.

The climb ladder, with the depth question as the worked example, is in the question bank under "Reformulation ladder".

## Sent material — verification (rule 8)

**When sent material appears to answer a pending question:**

1. **Quote the exact passage back**, and say where it came from. Not a paraphrase — a paraphrase is already an interpretation, and interpretation is the thing being checked.
2. **Ask one question: is this the answer, and is it still true?** Both halves matter. A document says what was true when it was written, and the user is the only authority on whether it still holds.
3. **Until they confirm, it is a candidate** — logged as `CANDIDATE (source)` in the transcript, never as an answer, and never carried into a read-back as though it were settled.
4. **On confirmation** it becomes a normal answer, `[YOU SAID]`, noting the document it came from and the question number that confirmed it.
5. **On correction, the user wins, and the discrepancy is itself a finding.** A document that misstates the real process is a live problem for whoever reads it next — log it and carry it into the synthesis risks section. Do not quietly discard the document version.
6. **One verification per turn.** Ten answers found in a document means ten verification questions, not one bundled list.
7. **Never skip the check because the passage looks unambiguous.** The cleanest-sounding paragraph is usually the one everyone quotes and nobody follows.


## Completeness machinery — Layers 4, 5, 6 (deep mode only)

**Layers 4, 5 and 6 carry completeness machinery — deep mode only.** Quick mode keeps its 15-question list and does none of this; running a pair matrix on a 15-question budget would defeat the point of quick.

| Layer | Machinery | Purpose |
|---|---|---|
| 4 | Re-open the naming question until **two consecutive rounds add nothing new** | "All components", proven rather than assumed |
| 4 | Two first-principles tests on every component: can it be split further and still mean something; does it exist by necessity or by convention | Makes "smallest meaningful thing" a checked claim, not a label |
| 4 | Three facets always asked, six only when load-bearing, **skips recorded per component** | Every component covered, and thin coverage looks thin |
| 5 | **Pair matrix**: every one of the N(N−1)/2 pairs logged as `ASKED` / `NOT RELATED` / `SKIPPED` — and `SKIPPED` must carry a reason | "Each component's relationships", with omissions visible instead of silent |
| 6 | Enumerate decision points until two consecutive rounds add nothing new, logged before working through them | No decision point quietly missed |

The shared principle: **an omission must be visible on paper.** These layers do not force more questions so much as they force every skip to be a recorded decision rather than a silent one. If `SKIPPED` pairs outnumber `ASKED` ones, say so at the layer read-back and let the user re-open any of them.


## Process contract — fields and chain check (Layer 8)

Per step, three fields are mandatory and four are conditional:

| Field | Status | The question, when it must be asked |
|---|---|---|
| Input | always | "What has to be in hand before this step can start?" |
| Output | always | "When this step is done, what exists that didn't before?" |
| Acceptance | always | "How does someone know this step was done *correctly*, not just done?" |
| Precondition | if the step can start prematurely | "What must be true, beyond having the input?" |
| Validation | if the input can arrive malformed | "What gets checked on the way in, and what happens when the check fails?" |
| Owner | if not obvious from Layer 4 | "Who performs it — a person, a system, or either?" |
| Timing | if delay has consequences | "How long does it take, and what happens if it runs over?" |

**Then run the chain check — this is the point of the layer.** For every adjacent pair of steps, compare step N's output against step N+1's input. Log each junction as one of:

| Verdict | Meaning |
|---|---|
| `MATCH` | The output is exactly what the next step needs |
| `GAP` | The next step needs something no prior step produces |
| `SURPLUS` | A step produces something nothing downstream consumes |
| `MISMATCH` | Both exist but the shape, unit, or timing differs |

`GAP`, `SURPLUS` and `MISMATCH` are **not** defects in the process — they are almost always gaps in the interview. Each one becomes an Ambiguity Ledger item and gets asked about. A surplus in particular usually means a consumer exists that was never named, which sends you back to Layer 4.

A chain where every junction is `MATCH` on the first pass is a warning sign, not a success: it usually means the steps were described at too coarse a grain to disagree.

