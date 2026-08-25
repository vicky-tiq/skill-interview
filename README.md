# skill-interview

A Claude Code skill that interviews you about your problem before anything gets built.

**English** · [Tiếng Việt](README.vi.md)

---

## `interview` — understand the problem before building it

A bilingual (**English / Tiếng Việt**) interview skill. Instead of guessing at your
intent from a one-line request, Claude interviews you: **one question at a time**,
across eight layers, until the whole picture can be *drawn* rather than guessed. Then it
writes a single self-contained HTML file — overview diagram first — that you can read,
correct, and share.

### Two depths

The first question settles language and depth together.

| | **Deep** | **Quick** |
|---|---|---|
| Questions | 50–85 | ~15, one pass |
| Per layer | Exhausted | The 1–2 highest-yield questions |
| Whole-picture diagram | Yes | **Yes** — never cut |
| Ends when | Nothing is ambiguous | Layer 7 closes, open items and all |
| Synthesis | 15 sections | 9 sections |
| Open questions | Must not exist | **Are the headline deliverable** |

Both cover all eight layers — quick is shallower, not narrower. It never pretends to
certainty it didn't earn: everything unresolved lands in a prominent *"what to nail down
before building"* section, each line saying what breaks if it's guessed wrong. A quick
interview that hides its gaps is worse than none, because it launders a guess into a
document.

Quick can become deep mid-interview without losing anything — same transcript format, so
it resumes at whichever layer has the most open items rather than restarting. It will
never escalate on its own: drifting from 15 questions to 45 would break the deal you made
at the first question.

Ask for it with `/interview` and pick at the prompt, or say *"phỏng vấn nhanh"* /
*"quick interview"* to skip straight to it.

The point is not documentation. The point is catching the misunderstanding *before*
it becomes a week of wrong code.

### The eight layers

| # | Layer | What it establishes |
|---|---|---|
| 0 | Root purpose & definition of success | That you're solving the right problem, and what "done" looks like |
| 1 | Context & constraints | Who's involved; which limits are real rules vs just habits |
| 2 | Fears & stakes | What *you* dread, and separately what your *end users* dread |
| 3 | Current vs desired state | Where it hurts today; what was tried and why it failed |
| 4 | Components | First-principles decomposition into the smallest meaningful things |
| 5 | Relationships | How those things bind together; what flows between them |
| 6 | Business logic | Every decision point, every branch, exact conditions and thresholds |
| 7 | Exceptions & edge cases | Failure branches, concurrency, zero/one/many, who may break the rules |

The two fear registers never get merged. Your fear of being blamed and a customer's fear
of losing money are different inputs: the first shapes what *not* to build, the second
shapes what to build.

### Proving coverage, not assuming it

Deep mode carries machinery whose only job is to make omissions visible. "All the components" and "each relationship" are claims, and unchecked claims are how an interview ends up feeling thorough while leaving holes.

- **Components are named to exhaustion** — the naming question re-opens until two consecutive rounds add nothing new. Nothing is ever called a "main" thing, because that framing drops the small ones, and the small ones are where the exceptions live.
- **Two first-principles tests run on every component** — can it be split further and still mean something, and does it exist by necessity or just by convention. Without the first, "smallest meaningful thing" is a label rather than something checked.
- **Facets are budgeted and skips are recorded** — three of the nine are always asked, the rest only when load-bearing, and what was skipped is written down per component. A thinly covered component looks thin instead of looking finished.
- **Relationships use a pair matrix** — every one of the N(N−1)/2 pairs is logged before any question is asked, each ending as `ASKED`, `NOT RELATED`, or `SKIPPED` with a stated reason. Skipping stays legitimate; skipping *invisibly* does not.
- **Decision points are enumerated to exhaustion too**, and logged before any is worked through.

Quick mode runs none of this — a pair matrix on a fifteen-question budget would defeat the point.

### Collected throughout, not in a layer

- **Concrete examples** — the moment you describe a general pattern ("big orders usually…"),
  it asks for one real case with real numbers. A rule with no instance behind it is a rule
  you *believe*, not one that *operates*.
- **Illustrations** — when something is hard to put in words, it stops asking for prose and
  asks for a screenshot, a product that already does it, or an analogy. Your own metaphor
  gets quoted verbatim, because it carries structure your prose doesn't.
- **References** — every document, link, competitor or person you cite gets captured: what
  it is, where it lives, why it matters. **Recorded, not read** — see below.

### The whole-picture checkpoint

Midway through — after relationships, before business logic — Claude stops asking and
*draws*. It sketches the entire problem as a box-and-arrow diagram in the chat and asks
one question: what's wrong with it, and what's missing?

This is the highest-yield moment in the interview. A wrong drawing gets corrected in
seconds; the same error buried in prose survives to the end. Whatever had to be invented
to make the drawing work is a gap, and gets marked as one.

### How it behaves

- **One question per turn.** No compound questions, no bulk questionnaires.
- **It does not research.** No reading your code, no web search, no guessing from
  existing files. It assumes it knows nothing, so it can't confuse its assumptions for
  your requirements. References you hand it are *recorded, not opened* — so nothing in
  the output is ever presented as verified when it wasn't.
- **"I don't know" is a valid answer.** It slices the question smaller instead of
  moving on — down a seven-rung ladder from general to one concrete instance to a
  forced binary.
- **Only you answer.** It never writes, completes, or tidies up an answer for you. If a
  reply arrives twice with different wording — a client-layer fault that happens — both
  copies are voided and the question is simply asked again. A transcript containing one
  sentence you didn't say is worse than one with a gap.
- **It never decides for you either.** If you don't answer a question — you'd rather talk
  about something else, or it seems unimportant — it may not supply the answer itself, not
  even as a default. It reformulates instead: parks what you did say, then breaks the
  question into parts and asks the simplest one first, climbing back up a rung at a time.
  Repeating the same wording is banned, because the second identical ask is what makes
  self-deciding feel justified.
- **It keeps an ambiguity ledger.** The interview only ends when the ledger is clear,
  or you say "that's enough".
- **It logs after every single answer,** so quitting mid-interview loses nothing.
  Run it again later and it resumes at the exact question, in the same language.

### Reading the output

Every claim in the synthesis carries one of three labels:

| Label | Meaning |
|---|---|
| `[YOU SAID]` / `[BẠN NÓI]` | Quoted from your own words |
| `[I INFERRED]` / `[TÔI SUY RA]` | Claude connected the dots; you never confirmed it |
| `[I PROPOSE]` / `[TÔI ĐỀ XUẤT]` | Claude's own idea — solution section only |

**Read `[I INFERRED]` first.** That is where misunderstandings hide, and separating
those three is the whole error-detection mechanism.

---

## Install

### Option A — as a plugin (recommended, updates cleanly)

In Claude Code:

```
/plugin marketplace add vicky-tiq/skill-interview
/plugin install interview@skill-interview
```

### Option B — copy the skill folder

```bash
git clone https://github.com/vicky-tiq/skill-interview.git
mkdir -p ~/.claude/skills
cp -R skill-interview/skills/interview ~/.claude/skills/
```

Or symlink instead of copy, so `git pull` keeps it current:

```bash
ln -sfn "$PWD/skill-interview/skills/interview" ~/.claude/skills/interview
```

### Option C — per-project

Copy `skills/interview` into a repo's `.claude/skills/` and commit it. Everyone who
clones that repo gets the skill with no setup.

---

## Usage

```
/interview
```

Optionally with the problem inline: `/interview our refund process is a mess`

The first question is which language to use — English or Tiếng Việt. Everything after
that stays in that language: questions, transcript, and the HTML.

A deep interview runs 50–85 questions, a quick one about 15. Output:

```
interview/<problem-slug>/transcript.md     # the full Q&A log, verbatim
interview/<problem-slug>/synthesis.html    # the readable, shareable synthesis
```

> **Note:** those files are written to your **current working directory**. If you run
> this inside a work repo, add `interview/` to that repo's `.gitignore` — interview
> content is usually internal information you don't want committed.

---

## What's in here

```
skills/interview/
├── SKILL.md                       # the process and its rules
└── references/
    ├── question-bank-en.md        # ~140 seed questions, English
    ├── question-bank-vi.md        # ~140 seed questions, Vietnamese
    ├── terminology.md             # EN↔VI map: labels, ledger, headings
    ├── transcript-template.md     # transcript structure + collection accumulators
    └── html-template.md           # 15-section synthesis structure and styling
```

Plain markdown, no code, no dependencies, no network access.

---

## License

MIT — see [LICENSE](LICENSE).
