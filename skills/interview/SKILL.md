---
name: interview
description: Interview the user to understand a problem thoroughly BEFORE building anything. Bilingual (English / Tiếng Việt) — asks which language first, then asks one question at a time across 7 layers (root purpose → context/constraints → current vs desired state → components → relationships → business logic decision trees → exceptions/edge cases), logs a transcript after every single answer, then synthesizes everything into one HTML file containing a problem map, visual diagrams, risks/contradictions, and a proposed solution. Triggers when the user types /interview, or says "interview me", "ask me questions until it's clear", "help me clarify this problem", "break down my problem", "make sure you understand what I mean", "get on the same page before we build", "phỏng vấn tôi", "hỏi tôi cho rõ", "làm rõ bài toán", "bóc tách bài toán". Works for any kind of problem: product/feature work, business process design, strategic decisions, or designing a new skill/agent.
---

# Problem Interview

Single goal: **get Claude and the user onto the same mental model of the problem** before discussing any solution or writing any code.

This skill is bilingual: **English** and **Tiếng Việt**. The interview language is chosen by the user in Step 0 and then stays fixed for the whole session, including the transcript and the synthesis file.

---

## 5 rules that must never be broken

**1. ONE QUESTION PER TURN.**
Each reply contains exactly one question. No compound questions ("What is A and how does B work?"). No "and also…" follow-ons. No numbered lists of questions for the user to answer in bulk. If you find yourself typing a second "?", delete it — it belongs to the next turn.

**2. DO NOT RESEARCH.**
Throughout the interview: do NOT read code, do NOT grep/glob the repo, do NOT WebSearch/WebFetch, do NOT infer the problem from existing files or memory. Assume you know nothing. Only exception: re-reading this interview's own transcript file to resume.

**3. KEEP ASKING UNTIL NOTHING IS AMBIGUOUS.**
There is no question limit — 40 or 60 questions is normal. Maintain an **Ambiguity Ledger** in the transcript; the interview ends only when the ledger has no open items. The user may stop you at any time by saying "that's enough" / "đủ rồi".

**4. WHEN AN ANSWER IS VAGUE, SLICE THINNER — NEVER SKIP.**
When an answer is vague, generic, or "I don't know": do not note it and move on. Split the question into a smaller slice and ask the smallest slice. Keep slicing until the user can answer. (Slicing ladder: in the question bank for the chosen language.)

**5. LOG AFTER EVERY ANSWER.**
The moment an answer arrives, append it to the transcript *before* asking the next question. Never batch the logging.

---

## Question formats — pick per situation

| Situation | Format |
|---|---|
| Need raw information only the user has | Open-ended — ask plainly, no hints, avoid leading |
| Need to settle a choice from a finite set | Multiple choice via `AskUserQuestion` (2–4 options) |
| You have enough to make a guess | State the hypothesis, ask them to confirm or correct |
| The user is stuck | Offer 2–3 possibilities to react to, then keep slicing |

Always leave room for their own words: `AskUserQuestion` includes an "Other" field by default — never force a pick from the list.

Open each turn with a position label — `**Q12 · Layer 4 (Relationships)**` or `**Câu 12 · Tầng 4 (Quan hệ)**`.

---

## Process

### Step 0 — Choose the interview language

**This is always the very first thing, before any question about the problem.** Ask it with `AskUserQuestion`, phrased in both languages so either kind of user can read it:

- **question:** `Which language should I interview you in? / Bạn muốn tôi phỏng vấn bằng ngôn ngữ nào?`
- **header:** `Language`
- **options:**
  - label `English` — description: `The whole interview, the transcript, and the final HTML synthesis will be in English.`
  - label `Tiếng Việt` — description: `Toàn bộ buổi phỏng vấn, biên bản và file HTML đúc kết sẽ bằng tiếng Việt.`

Skip this question only in two cases:
- The user already stated a language explicitly (e.g. "interview me in Vietnamese").
- You are resuming an existing transcript — read the language from its `Language:` field and keep it. Never switch language mid-interview unless the user asks.

Once chosen, **everything** is in that language: questions, read-backs, transcript, section headings, content labels, and the synthesis HTML. Load the matching question bank:

| Language | Question bank | Labels & headings |
|---|---|---|
| English | `references/question-bank-en.md` | English column of the terminology map |
| Tiếng Việt | `references/question-bank-vi.md` | Vietnamese column of the terminology map |

The terminology map (labels, ledger statuses, section headings in both languages) lives in `references/terminology.md`. Read it once after the language is chosen.

### Step 1 — Initialize

1. If the user hasn't stated the problem yet, ask it as the first content question — in the chosen language:
   - EN: *"What's the problem you want me to understand? Just talk it through — it doesn't need to be organized."*
   - VI: *"Bài toán bạn muốn tôi hiểu là gì? Cứ kể tự nhiên, chưa cần gọn gàng."*
2. Derive a kebab-case slug for the problem (unaccented for Vietnamese).
3. Create `interview/<slug>/transcript.md` following `references/transcript-template.md`, recording the chosen language in the `Language:` field.
4. If that file already exists → read it, report which layer and question number you're on, and resume from exactly there in its recorded language. Never re-ask anything already in the transcript.

### Steps 2–8 — The seven layers

Work through them in order; exhaust one before moving on.

| Layer | Name (EN) | Tên (VI) | Purpose |
|---|---|---|---|
| 0 | Root purpose & definition of success | Mục đích gốc & định nghĩa thành công | Confirm you're solving the right problem, and know what "done" looks like |
| 1 | Context & constraints | Bối cảnh & ràng buộc | Who's involved; which limits are real vs merely assumed |
| 2 | Current vs desired state | Hiện trạng vs mong muốn | Where it hurts today; what's been tried and why it failed |
| 3 | Components | Thành phần | First-principles decomposition into the smallest still-meaningful "things" |
| 4 | Relationships | Quan hệ | How components bind to each other; what flows between them |
| 5 | Business logic (decision tree) | Logic nghiệp vụ (cây quyết định) | Every decision point, all branches, exact conditions |
| 6 | Exceptions & edge cases | Ngoại lệ & trường hợp biên | Failure branches, concurrency, zero/one/many, who may break the rules |

The seed questions are **prompts, not a form to fill in**. Real questions must grow out of the user's previous answer, reusing their exact vocabulary.

**Closing a layer:** at the end of each layer, read back 3–6 bullets of what you understood, then ask exactly one question — EN: *"Did I get this right, and what's missing?"* / VI: *"Tôi hiểu đúng chưa, và thiếu gì không?"* If wrong or incomplete → correct it and keep asking within that layer. If confirmed → record the layer close in the transcript and advance.

**In Layer 5, go depth-first:** pick one decision point and exhaust every branch of it (including the default branch and the "none of the above" branch) before moving to the next decision point. Never hop sideways between branches.

### Step 9 — Residual ambiguity sweep

Re-read the whole transcript and hunt for:
- Items still open in the Ambiguity Ledger
- Two answers that **contradict each other**
- Nouns/terms the user used that were never defined
- Numbers or thresholds answered with "it depends" / "tuỳ", "around" / "khoảng" — no concrete value
- Decision branches with no precise condition
- Places where you are **inferring** rather than having been **told**

Keep asking one question at a time until the ledger is clear. This step gets skipped most often and delivers the most value.

### Step 10 — Synthesize to HTML

Only when the Ambiguity Ledger is clear, or the user says "that's enough" / "đủ rồi".

Write `interview/<slug>/synthesis.html` following `references/html-template.md`, **in the chosen language** — headings and content labels from the matching column of the terminology map. Required:
- **Fully self-contained**: inline CSS, diagrams as **inline SVG** (no CDN, no mermaid — so it opens offline and can be published as an Artifact).
- **Three content labels, visually distinct**: `[YOU SAID]` / `[I INFERRED]` / `[I PROPOSE]`, or `[BẠN NÓI]` / `[TÔI SUY RA]` / `[TÔI ĐỀ XUẤT]`. Never mix them in one statement.
- The proposed solution goes **last**, clearly separated from the problem understanding.

Then send the file to the user (`SendUserFile`) and ask whether they want it published as an Artifact for sharing — never publish unprompted.

---

## Guarding against common failure modes

- **Leading the witness.** Don't ask "it's for performance reasons, right?" with no basis. Ask "why?" first.
- **Jumping to solutions mid-interview.** If an idea occurs to you, write it into the *Parked ideas* section of the transcript and say nothing — voicing it frames the user's thinking.
- **Accepting a word without its meaning.** When the user says "order", "approved", "VIP customer" / "đơn hàng", "duyệt", "khách VIP" — each such word earns its own definition question. The most familiar words are the ones most often misunderstood.
- **Ignoring "usually" / "thường thì".** It means exceptions exist. Ask about the exception immediately.
- **Accepting "it depends" / "tuỳ tình huống".** That is an unstated decision tree. Dig it out.
- **Treating constraints as real.** For every constraint, ask one more question: "if this constraint were removed, what breaks — is it a rule or a habit?"
- **Drifting language.** Once the language is set, do not slip back into the other one, not even for headings or labels in the output file.
