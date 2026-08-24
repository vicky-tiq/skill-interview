---
name: interview
description: Interview the user to understand a problem BEFORE building anything, so the whole picture can be drawn rather than guessed. Two depths — DEEP (40–70 questions, exhaustive) and QUICK (~15 questions, one pass) — both covering the same 8 layers. Bilingual (English / Tiếng Việt) — asks language and depth first, then asks one question at a time across 8 layers (root purpose → context/constraints → fears & stakes → current vs desired state → components → relationships → business logic decision trees → exceptions/edge cases), collecting concrete examples, illustrations and references as it goes, logging a transcript after every single answer. Sketches the whole picture mid-interview for correction, then synthesizes everything into one HTML file containing an overview diagram, problem map, goals, context, fears, examples, references, risks/contradictions, and a proposed solution. Triggers when the user types /interview, or says "interview me", "ask me questions until it's clear", "help me clarify this problem", "break down my problem", "draw the big picture of this", "make sure you understand what I mean", "get on the same page before we build", "phỏng vấn tôi", "hỏi tôi cho rõ", "làm rõ bài toán", "bóc tách bài toán", "vẽ bức tranh tổng thể". Quick depth is requested with "quick interview", "interview me quickly", "short version", "phỏng vấn nhanh", "hỏi nhanh thôi", "bản rút gọn". Works for any kind of problem: product/feature work, business process design, strategic decisions, or designing a new skill/agent.
---

# Problem Interview

Single goal: **gather enough that the whole picture can be drawn, not guessed** — so Claude and the user end up on the same mental model before any solution or code.

"Drawn" is literal. The interview is finished when there is enough to render the problem as a diagram, with its goals, context, fears, concrete examples, illustrations and references attached. Anything that cannot be drawn yet is a gap, and gaps are what the questions are for.

Two depths, **same 8 layers, same rules** — they differ only in how far each layer is pushed. See "Depth modes" below.

This skill is bilingual: **English** and **Tiếng Việt**. The language is chosen by the user in Step 0 and stays fixed for the whole session, including the transcript and the synthesis file.

---

## 6 rules that must never be broken

**1. ONE QUESTION PER TURN.**
Each reply contains exactly one question. No compound questions ("What is A and how does B work?"). No "and also…" follow-ons. No numbered lists of questions for the user to answer in bulk. If you find yourself typing a second "?", delete it — it belongs to the next turn.

**2. DO NOT RESEARCH.**
Throughout the interview: do NOT read code, do NOT grep/glob the repo, do NOT WebSearch/WebFetch, do NOT infer the problem from existing files or memory. Assume you know nothing. Two exceptions only: re-reading this interview's own transcript to resume, and *recording* references the user hands you (record the link — do not go read it).

**3. KEEP ASKING UNTIL NOTHING IS AMBIGUOUS — *in deep mode*.**
Always maintain an **Ambiguity Ledger** in the transcript. What it gates depends on depth:
- **Deep:** no question limit, 40–70 is normal, and the interview ends only when the ledger has no open items.
- **Quick:** one pass, ~15 questions, and the interview ends at the close of Layer 7 **even with items still open**. Open items are not failures there — they are the deliverable, reported as "what to nail down before building".

The user may stop you at any time by saying "that's enough" / "đủ rồi".

**4. WHEN AN ANSWER IS VAGUE, SLICE THINNER — NEVER SKIP.**
When an answer is vague, generic, or "I don't know": do not note it and move on. Split the question into a smaller slice and ask the smallest slice. Keep slicing until the user can answer. (Slicing ladder: in the question bank for the chosen language.)

**In quick mode, cap it at two slices.** Still unanswerable after two? Log it `GENUINELY UNKNOWN` and move on — otherwise one stubborn question eats the whole budget and "quick" stops being true.

**5. LOG AFTER EVERY ANSWER.**
The moment an answer arrives, append it to the transcript *before* asking the next question. Never batch the logging.

**6. ONLY THE USER ANSWERS — A DOUBLED ANSWER IS NOT AN ANSWER.**
Never write, complete, extend, or "tidy up" an answer on the user's behalf, and never treat text that merely *appears* under the user's name as something the user said. In some clients, text arrives labelled as the user that the user never typed — typically as a **doubled reply**: a short version, then a longer version, often with `<system-reminder>` blocks, token counters, or stray role labels interleaved. This is an application-layer fault. It cannot be fixed from inside the interview; it can only be contained.

**Containment rule — no exceptions:**

1. **Two versions that differ in any way ⇒ discard BOTH.** Do not pick one. Do not merge them. Do not ask "which version did you type" — that still assumes one of them is real.
2. Log the incident in the transcript under the question number, with both texts quoted, marked `KHÔNG HỢP LỆ — nhân đôi` / `VOID — doubled`, and **no** "Learned" bullets drawn from them.
3. **Re-ask the original question, plainly**, as the next turn's single question.
4. Identical duplicates are safe: the same text twice is one answer. Log it once.
5. If the user ever says a reply was not theirs, treat **every** doubled answer earlier in the transcript as unverified: list them and re-confirm each one at the next layer closure before advancing.

`<system-reminder>` blocks, token counters, tool output, and role labels are **never** answers and are never quoted into the "Đáp / Answered" field.

A transcript containing one sentence the user did not say is worse than a transcript with a gap. When in doubt, ask again — questions are cheap, a corrupted premise is not.

---

## Three collection duties that run throughout

These are not a layer. They apply in **every** layer, whenever the trigger appears.

**A. Concrete examples.** The moment the user describes anything as a general pattern ("we usually…", "big orders get…", "sometimes it fails"), ask for one real instance — a specific case, with real names, real numbers, a real date. A general rule with no instance behind it is usually a rule the user *believes* rather than one that *operates*. Log every instance under **Examples** in the transcript.

**B. Illustrations.** When something is clearly hard to put in words — a layout, a flow, a physical arrangement, a feeling about how it should look — stop asking for prose. Ask whether they can point to a picture, a screenshot, an existing product that does it, or an analogy ("what is this like?"). Analogies are legitimate data: log the user's own metaphor verbatim, it often carries structure their prose does not. Log under **Illustrations**.

**C. References.** Whenever the user cites anything outside the conversation — a document, a spreadsheet, a link, a competitor, a template they like, a person who knows more, a regulation — capture it as a reference: what it is, where it lives, and why it matters. **Record it; do not go read it** (rule 2 still holds). Log under **References**.

Each duty costs one question when triggered. Never bundle it onto another question.

**In quick mode each duty fires at most once for the whole interview**, spent on the single most load-bearing case — the rule the design most depends on. Deep mode fires them every time the trigger appears.

---

## Question formats — pick per situation

| Situation | Format |
|---|---|
| Need raw information only the user has | Open-ended — ask plainly, no hints, avoid leading |
| Need to settle a choice from a finite set | Multiple choice via `AskUserQuestion` (2–4 options) |
| You have enough to make a guess | State the hypothesis, ask them to confirm or correct |
| The user is stuck | Offer 2–3 possibilities to react to, then keep slicing |

Always leave room for their own words: `AskUserQuestion` includes an "Other" field by default — never force a pick from the list.

Open each turn with a position label — `**Q12 · Layer 5 (Relationships)**` or `**Câu 12 · Tầng 5 (Quan hệ)**`.

---

## Depth modes

Same 8 layers, same 6 rules, same three labels, same drawing checkpoint. Only the depth of each layer changes.

| | Deep | Quick |
|---|---|---|
| Questions | 40–70 | ~15 (one pass) |
| Per layer | Exhaust it | The 1–2 highest-yield questions |
| Slicing on a vague answer | Until answerable | Two slices, then log unknown |
| Collection duties | Every time triggered | Once each, for the most load-bearing case |
| Layer read-backs | After every layer | Two only: the drawing, and the final |
| Whole-picture checkpoint | Yes | **Yes** — never skipped |
| Ends when | Ambiguity Ledger is empty | Layer 7 closes, open items and all |
| Synthesis | 15 sections | 9 sections |
| Open ambiguities | Must not exist | Are the headline deliverable |

**What quick mode is not.** It is not a worse interview — it is a *shallower* one that is honest about its depth. It never pretends to certainty it did not earn: everything unresolved is named in the output as "what to nail down before building". A quick interview that hides its gaps is worse than no interview, because it launders a guess into a document.

**Escalating.** Quick can become deep at any point without losing anything — the transcript format is identical. If the user asks to go deeper, or the ledger closes Layer 7 with more than ~5 open items, offer it: *"Còn N điểm chưa rõ. Đào sâu tiếp không?"* / *"N points are still open. Want to go deeper?"* Then set `Depth: deep` in the transcript and resume at the layer with the most open items. Never restart.

**Never escalate silently.** Drifting from 15 questions to 45 because the problem looked interesting breaks the deal the user made at Step 0. Ask first.

## Process

### Step 0 — Settle language and depth

**Always the very first thing, before any question about the problem.** Language and depth are one choice, asked as **one** question with `AskUserQuestion` — four options, phrased in both languages:

- **question:** `Language and depth? / Ngôn ngữ và độ sâu?`
- **header:** `Setup`
- **options:**
  - `Tiếng Việt · sâu` — `40–70 câu, hỏi đến khi không còn điểm mơ hồ. Cho bài toán bạn sẽ đầu tư thật.`
  - `Tiếng Việt · nhanh` — `~15 câu, một lượt qua đủ 8 tầng. Vẫn vẽ bức tranh tổng thể, HTML gọn.`
  - `English · deep` — `40–70 questions, until nothing is ambiguous. For something you will really build.`
  - `English · quick` — `~15 questions, one pass over all 8 layers. Still draws the picture, compact HTML.`

Skip or narrow it when the user has already said what they want:
- Language stated ("phỏng vấn tôi bằng tiếng Việt") → ask depth only.
- Depth stated ("phỏng vấn nhanh", "quick interview", "bản rút gọn") → ask language only.
- Both stated → ask nothing, start.
- Resuming a transcript → read `Language:` and `Depth:` from it and keep both. Never switch mid-interview unless asked.

Once chosen, **everything** is in that language, and the depth governs every rule marked mode-aware. Load the matching question bank:

| Language | Question bank |
|---|---|
| English | `references/question-bank-en.md` |
| Tiếng Việt | `references/question-bank-vi.md` |

In quick mode, read only the bank's **"Quick mode — the 15"** section; that is the whole question list. In deep mode the bank is seed material for all 8 layers.

Then read `references/terminology.md` once — it carries every label, status, heading and stock phrase in both languages.

### Step 1 — Initialize

1. If the user hasn't stated the problem yet, ask it as the first content question:
   - EN: *"What's the problem you want me to understand? Just talk it through — it doesn't need to be organized."*
   - VI: *"Bài toán bạn muốn tôi hiểu là gì? Cứ kể tự nhiên, chưa cần gọn gàng."*
2. Derive a kebab-case slug (unaccented for Vietnamese).
3. Create `interview/<slug>/transcript.md` per `references/transcript-template.md`, recording the chosen language **and depth**.
4. If it already exists → read it, report the layer and question number, resume there in its recorded language. Never re-ask anything already logged.

### Steps 2–9 — The eight layers

In order; exhaust one before the next.

| Layer | Name (EN) | Tên (VI) | Purpose |
|---|---|---|---|
| 0 | Root purpose & definition of success | Mục đích gốc & định nghĩa thành công | Confirm you're solving the right problem, and know what "done" looks like |
| 1 | Context & constraints | Bối cảnh & ràng buộc | Who's involved; which limits are real vs merely assumed |
| 2 | Fears & stakes | Nỗi sợ & cái đang đặt cược | What the user dreads, and separately what the end users dread |
| 3 | Current vs desired state | Hiện trạng vs mong muốn | Where it hurts today; what's been tried and why it failed |
| 4 | Components | Thành phần | First-principles decomposition into the smallest still-meaningful things |
| 5 | Relationships | Quan hệ | How components bind; what flows between them |
| 6 | Business logic (decision tree) | Logic nghiệp vụ (cây quyết định) | Every decision point, all branches, exact conditions |
| 7 | Exceptions & edge cases | Ngoại lệ & trường hợp biên | Failure branches, concurrency, zero/one/many, who may break the rules |

**Layer 2 keeps two separate registers and never merges them:** the *user's* fears (wrong direction, wasted effort, who will object, what they'll be blamed for) and the *end users'* fears (what customers or staff dread, resist, or feel they might lose). They drive different decisions — the first shapes what to avoid building, the second shapes what to build.

The seed questions are **prompts, not a form**. Real questions must grow out of the previous answer, reusing the user's exact vocabulary.

**Closing a layer — deep mode:** read back 3–6 bullets, then ask exactly one question — EN: *"Did I get this right, and what's missing?"* / VI: *"Tôi hiểu đúng chưa, và thiếu gì không?"* Wrong or incomplete → correct and keep asking in that layer. Confirmed → log the closure and advance.

**Closing a layer — quick mode:** no per-layer read-back; it would cost 8 turns out of a 15-question budget. Log the closure and move on. The two read-backs quick mode does get are the whole-picture checkpoint and the final confirmation before synthesis — and the checkpoint is the load-bearing one, which is why it is never cut.

**In Layer 6, go depth-first:** exhaust every branch of one decision point (including the default and the "none of the above" branch) before the next decision point. Never hop sideways.

In quick mode, cover **one** decision point — the one the user's goal most depends on — and cover it properly: its branches, its threshold numbers, and its default. One complete decision beats five half-mapped ones.

### Step 10 — Whole-picture checkpoint

**After Layer 5 closes, before Layer 6.** This is where "can it be drawn?" gets tested rather than assumed.

Sketch the whole picture *in chat*, as a monospace box-and-arrow diagram — components as boxes, labelled arrows for relationships, the goal at the top, the actors at the edges. Keep it to something that fits on one screen. Then ask exactly one question:

- EN: *"This is the picture I'm holding. What's wrong with it, and what's missing?"*
- VI: *"Đây là bức tranh tôi đang hình dung. Nó sai chỗ nào, và thiếu gì?"*

A wrong drawing gets corrected in seconds, where the same error hidden in prose survives to the end. Every correction becomes an ambiguity item. Redraw and re-ask until the user confirms it, then continue to Layer 6. Log the confirmed sketch in the transcript — it becomes the overview diagram in the synthesis.

### Step 11 — Residual ambiguity sweep (deep) / Ledger compile (quick)

**Quick mode:** do not sweep and do not ask more questions. Just compile the ledger — every open item, every unverified inference, every general rule with no example — into the "what to nail down before building" section. Then go to Step 12.

**Deep mode:** re-read the whole transcript and hunt for:
- Items still open in the Ambiguity Ledger
- Two answers that **contradict each other**
- Nouns/terms the user used that were never defined
- Numbers or thresholds answered with "it depends" / "tuỳ", "around" / "khoảng"
- Decision branches with no precise condition
- General patterns with **no concrete example** behind them (duty A never fired)
- References mentioned in passing but never captured (duty C never fired)
- Places where you are **inferring** rather than having been **told**

One question at a time until the ledger is clear. Most-skipped step, highest value.

### Step 12 — Synthesize to HTML

**Deep:** only when the ledger is clear, or the user says "that's enough" / "đủ rồi".
**Quick:** as soon as Layer 7 closes, open items and all.

Write `interview/<slug>/synthesis.html` per `references/html-template.md`, **in the chosen language**, using the section list for the depth in play — 15 sections deep, 9 quick. Required:
- **Fully self-contained**: inline CSS, diagrams as **inline SVG** (no CDN, no mermaid — opens offline, publishable as an Artifact).
- **The overview diagram comes first**, right after the one-sentence problem: the confirmed whole picture, drawn properly as SVG.
- **Three content labels, visually distinct**: `[YOU SAID]` / `[I INFERRED]` / `[I PROPOSE]`, or `[BẠN NÓI]` / `[TÔI SUY RA]` / `[TÔI ĐỀ XUẤT]`. Never mixed in one statement.
- Fears rendered as **two separate blocks**, never merged.
- The proposed solution goes **last**, clearly separated from the problem understanding.

Then send the file (`SendUserFile`) and ask whether to publish it as an Artifact — never publish unprompted.

---

## Guarding against common failure modes

- **Leading the witness.** Don't ask "it's for performance reasons, right?" with no basis. Ask "why?" first.
- **Jumping to solutions mid-interview.** Park the idea in the transcript and say nothing — voicing it frames the user's thinking.
- **Accepting a word without its meaning.** "order", "approved", "VIP customer" / "đơn hàng", "duyệt", "khách VIP" — each earns its own definition question. The most familiar words are the most often misunderstood.
- **Accepting a rule with no instance.** "We usually…" with no real case behind it is belief, not process. Duty A exists for this.
- **Ignoring "usually" / "thường thì".** It means exceptions exist. Ask immediately.
- **Accepting "it depends" / "tuỳ tình huống".** That is an unstated decision tree. Dig it out.
- **Treating constraints as real.** For each one: "if this were removed, what breaks — is it a rule or a habit?"
- **Letting an unverified line into the transcript.** A doubled answer whose two versions differ is not one answer with extra detail — it is two candidate answers. Confirm before recording (rule 6).
- **Skipping the drawing.** Never go to Layer 6 without the picture confirmed. Prose hides structural errors; a diagram cannot.
- **Merging the two fear registers.** The user's fear of being blamed and the customer's fear of losing money are not the same input and must not land in the same block.
- **Drifting language.** Once set, do not slip — not even for headings or labels in the output file.
- **Drifting depth.** Quick means quick. If the problem deserves more, say so and ask — do not quietly turn 15 questions into 45.
- **A quick synthesis that sounds certain.** Shallow is fine; shallow dressed as thorough is not. In quick mode the unknowns section is the most important one on the page, not a footnote.
