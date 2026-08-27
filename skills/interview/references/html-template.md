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

## Deep mode — 19 sections, in this order

Heading wording per language: see the "Synthesis HTML section headings" table in `terminology.md`.

1. **The problem in one sentence** — hero, large type. If the user produced such a sentence, quote it verbatim.
2. **The whole picture** — the overview diagram, **twice**: the confirmed ASCII sketch from the checkpoint in a `<pre>` block, then the same picture drawn properly as inline SVG. The SVG is for reading; the ASCII is for *using* — it can be pasted into a prompt, a ticket, or a chat message, which an SVG cannot. Keep them identical in content; if drawing the SVG revealed something the sketch got wrong, fix the sketch too rather than letting the two disagree. Both come from the sketch the user confirmed at the whole-picture checkpoint. Drawn properly, that means: the goal at the top, actors at the edges, components as boxes, labelled arrows between them. One screen, no scrolling, readable without the rest of the document. A reader who sees only this section should be able to describe the problem back. Everything after it is detail.
3. **Root purpose & definition of success** — why this matters, the observable done-signal, the target number.
4. **Context & constraints** — table of stakeholders / role / what they care about. Constraints table separating **hard rules** from **habits**.
5. **Fears & stakes** — **two clearly separate blocks, never merged**: the user's own fears, and the end users' fears. For each fear, note what it implies for the design. Include the unspoken objections — they are usually the load-bearing ones.
6. **Current → Desired** — two parallel columns. Include an "Already tried and ruled out" block so nothing rejected gets re-proposed.
7. **Component map** — one card per component: one-sentence definition, owner, states, mandatory attributes, unit of measure.
8. **Relationship diagram** — SVG: boxes are components, arrows carry verb labels, note cardinality (1–1 / 1–n / n–n) and mandatory vs optional (solid vs dashed line). This is the zoomed-in version of section 2.
9. **Decision trees** — one SVG per decision point: diamonds for conditions, branch labels with **concrete conditions including numbers**, default branch shaded differently. Plus a table: decision point / decider / inputs / branches / resulting state / reversible?
10. **Exceptions & edge cases** — table: scenario / how it's handled today / who handles it / settled or still open.
11. **Worked examples** — the real cases collected under duty A. Each one: what happened, when, the actual numbers, and which rule or branch above it demonstrates. A rule with no example here is a rule to distrust — say so explicitly.
12. **Illustrations & analogies** — the user's own metaphors quoted verbatim, plus any screenshot, file, or product they pointed to. If they said "it's like a kitchen ticket rail", that sentence goes here in quotes, because it carries structure their prose did not.
13. **References** — table: what it is / where it lives / who owns it / why it matters. Mark each as **recorded, not read** — the interview does not open sources, and the reader must not assume the content was verified.
14. **Risks, contradictions & unknowns** — three separate blocks:
    - *Contradictions*: two answers that don't line up, quoting both with question numbers.
    - *Unverified assumptions*: every `[I INFERRED]` the user never confirmed.
    - *Genuine unknowns*: the `GENUINELY UNKNOWN` ledger rows, each with "what breaks if we guess wrong".
    - *Stale documents*: every place the user's own material said one thing and the user said another, quoting both. This matters beyond the interview — whoever reads that document next will be misled the same way. Name the document and who else works from it.
15. **Process contract** — the buildable part of the document. One row per step: input, output, acceptance criterion, owner, and (where asked) precondition, validation and timing. Cells that were inferred rather than told carry `[I INFERRED]` inline, not just in section 14 — the reader must see *which cell* is soft while looking at the table, not after it. An acceptance criterion that merely restates the output is a defect: flag it in place rather than printing it as if it were a test.
16. **Chain check** — one row per junction between adjacent steps, each `MATCH` / `GAP` / `SURPLUS` / `MISMATCH`, with the detail and the ledger item id for every non-match. Put the non-matches **first**; a reader scanning this section is looking for what does not line up, not for reassurance. If every junction is `MATCH`, say plainly that this usually means the steps were described too coarsely to disagree — do not present it as a clean bill of health.
17. **Validation & acceptance** — pulled out of the table into a checkable list, because this is the part someone will actually work from: per step, what is checked on the way in, what happens when the check fails, and the observable test that says the step is done correctly. Anything with no test yet appears here as an explicit hole, not as an omission.
18. **Fear → countermeasure map** — one row per fear from section 5, both registers, in the user's own words. For each: which specific measure in the proposal addresses it, how it addresses it, and **what residual risk is left over**. A fear with no countermeasure gets a row saying so plainly — that is more useful than an absent row, because it tells the reader which anxiety the plan does not answer. Never merge a user's fear with an end user's fear into one row; they are answered by different things.

    This section exists because "the solution addresses the fears" buried in a paragraph is unverifiable. A reader must be able to run a finger down their own list of fears and see, for each one, whether it was handled. Residual risk is mandatory: a countermeasure that claims to eliminate a fear entirely is almost always hiding the leftover.
19. **Proposed solution** — fully separated, with a visible divider and an opening line: *"Everything below this line is my proposal, not something you told me."* Covers: the approach, why it fits the stated constraints **and answers the fears mapped in section 18**, implementation steps, and what it deliberately does **not** do.

**Conditional appendix — component split (only when the problem is building an automation or agent system).** The process contract already contains what is needed to answer it, so it costs little: a step whose input and output contract is clean is a candidate boundary, and a junction marked `GAP` or `MISMATCH` is a boundary that is *not* yet clean. Propose how many separate units to build, where the seams fall, and the reason for each seam — citing the specific contract row that justifies it. Label the whole appendix `[I PROPOSE]`. Where the chain check found unresolved junctions, say plainly that those seams cannot be settled yet, and why. Omit this appendix entirely for problems that are not about building a system.

Closing appendix: a link to `transcript.md` plus interview stats (total questions, ambiguities resolved, unknowns remaining, examples collected, references captured, junctions matched out of total).

## Quick mode — 11 sections

A quick interview must not produce a document that *looks* as authoritative as a deep one. Fewer sections, and the unknowns are promoted rather than buried.

1. **The problem in one sentence**
2. **The whole picture** — the confirmed overview diagram, same drawing standard as deep mode. Never cut this; it is the most information per pixel in the file.
3. **Purpose & definition of success** — including the number, if there is one.
4. **Constraints & who decides** — and which constraints are hard rules vs habits.
5. **Fears** — the two registers, still separate, one or two items each.
6. **Components & how they relate** — deep mode's sections 7 and 8 merged into one table plus one small diagram.
7. **The decision point that matters most** — branches, exact conditions, default, reversible?
8. **What to nail down before building** — *the headline section.* Every open ledger item, every unverified inference, every rule with no example behind it. Each line says what breaks if it is guessed wrong. Style it as the most prominent block on the page after the diagram.
9. **Process contract, compact** — one table: step, input, output. Main path only, no preconditions or timing. Then the chain check underneath it, non-matches first. This is the whole reason a quick interview is worth running: even a shallow pass shows you where the steps do not join up.
10. **Fear → countermeasure, compact** — one row per fear, what addresses it, what is left over. Same rule as deep mode: a fear with nothing against it gets a row saying so.
11. **Suggested next step** — labelled `[I PROPOSE]`, and explicitly scoped: what can safely start now, and what must wait for section 8.

Add a banner at the top of the file, in the interview language: *"Quick interview — 15 questions. This is a shallow pass; section 8 lists what it did not establish."* / *"Phỏng vấn nhanh — 15 câu. Đây là một lượt quét nông; mục 8 liệt kê những gì chưa xác lập được."*

No worked-examples, illustrations, or references sections unless a duty actually fired — an empty section implies nothing was there, which is a different claim from "we did not look".

## Drawing the overview diagram (section 2)

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
