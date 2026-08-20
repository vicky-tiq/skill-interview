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
| `[YOU SAID]` | The user said it; quotable from the transcript | The default. Most of the file must be this. |
| `[I INFERRED]` | Claude reasoned it from what was said; not directly confirmed | When you had to connect pieces |
| `[I PROPOSE]` | Claude's own idea, never stated by the user | Only in the closing solution section |

Never mix the three within a single statement. The user must be able to spot instantly which words are theirs and which Claude added — that separation is the error-detection mechanism.

## 15 sections, in this order

Heading wording per language: see the "Synthesis HTML section headings" table in `terminology.md`.

1. **The problem in one sentence** — hero, large type. If the user produced such a sentence, quote it verbatim.
2. **The whole picture** — the overview diagram, as inline SVG. This is the sketch the user confirmed at the whole-picture checkpoint, drawn properly: the goal at the top, actors at the edges, components as boxes, labelled arrows between them. One screen, no scrolling, readable without the rest of the document. A reader who sees only this section should be able to describe the problem back. Everything after it is detail.
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
15. **Proposed solution** — fully separated, with a visible divider and an opening line: *"Everything below this line is my proposal, not something you told me."* Covers: the approach, why it fits the stated constraints **and answers the fears in section 5**, implementation steps, and what it deliberately does **not** do.

Closing appendix: a link to `transcript.md` plus interview stats (total questions, ambiguities resolved, unknowns remaining, examples collected, references captured).

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
