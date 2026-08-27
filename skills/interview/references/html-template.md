# Synthesis HTML template

File: `interview/<slug>/synthesis.html`

**Language:** write the whole file in the language chosen in Step 0. Section headings and content labels come from the matching column of `terminology.md`. Never mix the two languages in one file — not even for headings.

## Technical requirements

- **Fully self-contained.** CSS inline in `<style>`. No CDN, no external fonts, no external scripts. It must open offline and be publishable as an Artifact (Artifacts block all outbound requests).
- **Diagrams as inline SVG.** No mermaid, no drawing libraries. Hand-written SVG using `currentColor` or CSS variables so it follows the theme.
- **Theme-aware.** Define the full light palette on `:root`, then override inside `@media (prefers-color-scheme: dark)`. `body` needs an explicit background.
- **Wide tables and diagrams** wrapped in a `div` with `overflow-x:auto`. The page must never scroll horizontally.

## The most important content rule

Every claim in the file carries exactly one of three labels (Vietnamese equivalents in `terminology.md`):

| Label | Meaning | When to use |
|---|---|---|
| `[YOU SAID]` | The user said it; quotable from the transcript — including answers found in their own material **after they confirmed them**, with the source named inline | The default. Most of the file must be this. |
| `[I INFERRED]` | Claude reasoned it from what was said; not directly confirmed | When you had to connect pieces |
| `[I PROPOSE]` | Claude's own idea, never stated by the user | Only in the closing solution section |

Never mix the three within a single statement. The user must be able to spot instantly which words are theirs and which Claude added — that separation is the error-detection mechanism.

## Deep mode — three deliverables, then the evidence behind them

Heading wording per language: see the "Synthesis HTML section headings" table in `terminology.md`.

The file is in three parts, and the order matters. **Part A is the result of the interview**: the diagram, the contract, and the acceptance criteria. Someone who reads only Part A should be able to act. Parts B and C exist to let them check Part A rather than take it on trust — evidence first, then what is still open.

Flat section lists bury the deliverable. A reader looking for what to build should not have to pass through fears, worked examples and references to reach it.

### Part A — the three deliverables

**A1. The whole picture.** The overview diagram, **twice**: the confirmed ASCII sketch in a `<pre>` block, then the same picture as inline SVG. SVG to read, ASCII to *use* — it pastes into a prompt, a ticket or a chat message, which SVG does not. Keep them identical; if drawing the SVG exposed something the sketch got wrong, fix the sketch too. Layout: goal at the top, actors at the edges, components as boxes, every arrow carrying a verb. Solid box for a component the user named, dashed for one you inferred. Anything invented to make the drawing connect is a gap, not a drawing detail — dash it and list it in C1. Under twelve boxes; more means the problem has sub-problems.

**A2. The contract.** One row per step: input, output, acceptance criterion, owner, plus precondition, validation and timing where they were asked. Inferred cells carry `[I INFERRED]` **inline in the cell**, not only in C1 — the reader must see which cell is soft while looking at the table.

Immediately below it, the **chain check**: every junction between adjacent steps as `MATCH` / `GAP` / `SURPLUS` / `MISMATCH`, with the detail and the ledger id for each non-match. **Non-matches first** — a reader scanning this is looking for what does not line up. If every junction is `MATCH`, say plainly that this usually means the steps were cut too coarsely to disagree; do not present it as a clean bill of health.

**A3. Acceptance.** Per step: what is checked on the way in, what happens when that check fails, and the observable test that says the step was done *correctly*. An acceptance criterion that restates the output is a defect — flag it in place rather than printing it as though it were a test. Steps with no test yet appear here as explicit holes.

**Each of the three ships as a copy-pasteable block.** The diagram already has its ASCII. Give the contract and the acceptance list a plain-text version too, in a `<pre>` a reader can select and paste into a spec, a ticket, or the next prompt. These three are what someone hands to whoever builds it; an artifact you cannot get out of the page is an artifact that gets retyped and mangled.

### Part B — the evidence behind them

Same content as before, now positioned as support rather than as peers of the deliverable.

B1. The problem in one sentence — quoted verbatim if the user produced one.
B2. Root purpose & definition of success — why it matters, the observable done-signal, the target number.
B3. Context & constraints — stakeholders table; constraints split into **hard rules** vs **habits**.
B4. Fears & stakes — **two separate blocks, never merged**: the user's fears and the end users'. Include the unspoken objections; they are usually load-bearing.
B5. Current → Desired — two columns, plus "already tried and ruled out" so nothing rejected gets re-proposed.
B6. Component map — one card per component: definition, owner, states, mandatory attributes, unit.
B7. Relationship diagram — SVG; verbs on arrows, cardinality, solid vs dashed for mandatory vs optional. The zoomed-in version of A1.
B8. Decision trees — one SVG per decision point; branch labels carry **concrete conditions including numbers**; default branch shaded differently. Plus the decider / inputs / branches / resulting state / reversible table.
B9. Exceptions & edge cases — scenario / handled how today / by whom / settled or open. Include the untrusted-input findings.
B10. Worked examples — real cases with real numbers, each naming the rule or branch it demonstrates. A rule with no example here is a rule to distrust; say so.
B11. Illustrations & analogies — the user's metaphors verbatim, plus anything they pointed at.
B12. References — what / where / who owns it / why it matters, each marked **recorded, not read**.

### Part C — what is still open, and what I propose

**C1. Risks, contradictions & unknowns** — four blocks: *contradictions* (both answers quoted with question numbers); *unverified assumptions* (every `[I INFERRED]` never confirmed); *genuine unknowns* (each with "what breaks if we guess wrong"); *stale documents* (where the user's own material said one thing and the user another — whoever reads that document next will be misled the same way; name it and who else works from it).

**C2. Fear → countermeasure map** — one row per fear from B4, in the user's words: what addresses it, how, and **what residual risk is left**. A fear with nothing against it gets a row saying so. Residual risk is mandatory: a countermeasure claiming to eliminate a fear entirely is usually hiding the leftover.

**C3. Proposed solution** — fully separated, with a visible divider and an opening line: *"Everything below this line is my proposal, not something you told me."* The approach, why it fits the constraints and answers C2, implementation steps, and what it deliberately does **not** do. A proposal is not a build; rule 9 still holds.

**Conditional appendix — component split**, only when the problem is building an automation or agent system. The contract already answers it: a step with a clean input/output contract is a candidate boundary, and a `GAP` or `MISMATCH` junction is a boundary that is not clean yet. Propose how many units, where the seams fall, and the contract row justifying each seam. Label it `[I PROPOSE]`. Where the chain check left junctions unresolved, say plainly that those seams cannot be settled yet. Omit entirely for problems that are not about building a system.

Closing appendix: a link to `transcript.md` plus interview stats (total questions, ambiguities resolved, unknowns remaining, examples collected, references captured, junctions matched out of total).

## Quick mode — the same three, compressed

A quick interview must not produce a document that *looks* as authoritative as a deep one. Same three-part shape, fewer rows, and the unknowns promoted rather than buried.

Banner at the top, in the interview language: *"Quick interview — 15 questions. This is a shallow pass; the open-items section lists what it did not establish."* / *"Phỏng vấn nhanh — 15 câu. Đây là một lượt quét nông; mục các điểm còn treo liệt kê những gì chưa xác lập được."*

**Part A — the three deliverables**
- A1. The whole picture — ASCII plus SVG, same drawing standard as deep mode. Never cut; it is the most information per pixel in the file.
- A2. The contract, compact — step, input, output, main path only. No preconditions or timing. Chain check underneath, non-matches first. This is why a quick interview is worth running at all: even a shallow pass shows where the steps do not join up.
- A3. Acceptance, compact — one observable test per step, or an explicit blank where there is none.

All three still ship as copy-pasteable blocks.

**Part B — the evidence**
- B1. The problem in one sentence.
- B2. Purpose & definition of success, including the number if there is one.
- B3. Constraints & who decides, hard rules vs habits.
- B4. Fears — both registers, still separate, one or two items each.
- B5. Components & how they relate — deep mode's component map and relationship diagram merged into one table plus one small diagram.
- B6. The decision point that matters most — branches, exact conditions, default, reversible?

No worked-examples, illustrations or references sections unless a duty actually fired. An empty section implies nothing was there, which is a different claim from "we did not look".

**Part C — open items**
- C1. **What to nail down before building** — *the most prominent block on the page after the diagram.* Every open ledger item, every unverified inference, every rule with no example, every unresolved junction. Each line says what breaks if it is guessed wrong.
- C2. Fear → countermeasure, compact — what addresses each fear, what is left over, and a row saying so where nothing does.
- C3. Suggested next step — labelled `[I PROPOSE]`, explicitly scoped: what can safely start now, and what must wait for C1.

## Drawing the overview diagram (A1)

This is the section that makes the file worth opening, so give it real effort.

- Lay it out top-to-bottom: **goal** → **the flow that produces it** → **the components it runs on**. Put actors (people, external systems) on the left and right edges, not in the middle.
- Use at most three visual weights: solid box for a component the user named, dashed box for something inferred, filled box for the goal. Nothing else — no gradients, no shadows, no icons.
- Label **every** arrow with a verb. An unlabelled arrow is a hidden assumption.
- Anything you had to infer to make the drawing work must be dashed **and** listed in section 14. If drawing it required inventing a connection, that is a gap in the interview, not a drawing detail.
- Keep it under roughly 12 boxes. If it needs more, the problem has sub-problems — draw the top level here and let sections 8 and 9 carry the detail.
- Give the `<svg>` a `viewBox`, no fixed `width`/`height`, and wrap it in `<div class="scroll">`.

## Starting skeleton

```html
<title>Problem synthesis — <name></title>
<style>
:root{
  --bg:#fbfaf8; --fg:#1a1a19; --muted:#6b6b66; --line:#e2e0da; --card:#ffffff;
  --said:#0f766e; --said-bg:#effbf8;
  --infer:#a16207; --infer-bg:#fdf9ec;
  --prop:#4338ca; --prop-bg:#f1f0fd;
  --warn:#b91c1c; --warn-bg:#fdf1f1;
  --fear:#9333ea; --fear-bg:#f8f0fe;
}
@media (prefers-color-scheme:dark){:root:not([data-theme="light"]){
  --bg:#121211; --fg:#eceae5; --muted:#9a9890; --line:#2e2d29; --card:#1a1a18;
  --said:#5eead4; --said-bg:#0d2a26;
  --infer:#fbbf24; --infer-bg:#2a2310;
  --prop:#a5b4fc; --prop-bg:#1c1b33;
  --warn:#fca5a5; --warn-bg:#2c1414;
  --fear:#d8b4fe; --fear-bg:#241033;
}}
:root[data-theme="dark"]{ /* repeat the dark block above verbatim */ }
body{background:var(--bg);color:var(--fg);margin:0;
  font:16px/1.65 -apple-system,BlinkMacSystemFont,"Segoe UI",system-ui,sans-serif;}
.wrap{max-width:920px;margin:0 auto;padding:48px 24px 96px;}
.tag{display:inline-block;font-size:11px;font-weight:700;letter-spacing:.04em;
  padding:2px 7px;border-radius:4px;vertical-align:2px;margin-right:6px;}
.tag-said{color:var(--said);background:var(--said-bg);}
.tag-infer{color:var(--infer);background:var(--infer-bg);}
.tag-prop{color:var(--prop);background:var(--prop-bg);}
.fear{border-left:3px solid var(--fear);background:var(--fear-bg);padding:12px 16px;margin:12px 0;}
.quote{border-left:3px solid var(--line);padding-left:14px;font-style:italic;color:var(--muted);}
.scroll{overflow-x:auto;}
svg{max-width:100%;height:auto;}
</style>
```

Use `class="tag tag-said"` etc. for the labels. Never rely on color alone — always include the words `YOU SAID` / `I INFERRED` / `I PROPOSE` (or `BẠN NÓI` / `TÔI SUY RA` / `TÔI ĐỀ XUẤT`) so it survives black-and-white printing.

## After writing the file

1. Send it to the user with `SendUserFile` (`display: "render"`).
2. Ask whether they want it published as an Artifact for sharing — **never publish unprompted**.
3. Update `transcript.md`: `Status: SYNTHESIZED`.
