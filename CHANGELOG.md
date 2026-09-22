# Changelog

Every change to the skill gets an entry here, newest first, with the reason rather than
just the description — six months from now the reason is the part nobody can reconstruct.

Version numbers live in `.claude-plugin/plugin.json`. A rule or layer change is a minor
bump; a refactor or doc change that alters no behaviour is a patch.

---

## 1.10.0 — 2026-09-22

**Rule 10: every question is concrete and stands on its own.**

Rules 1–9 governed how many questions and what to ask. Nothing governed how each one is
written, and the test suite kept catching the consequence: turns that announced *"tôi sẽ
cắt nhỏ ra, hỏi từng miếng một"* and then ended without asking anything.

Two failure modes are now named and banned. **Abstract** — a question that could have been
asked of any problem (*"What are the main components?"*), which makes the user do the
framing work the interviewer is supposed to do. **Bare** — stripped of everything that made
it answerable (*"Who approves?"*, *"How long?"*), leaving the user unable to tell what is
being asked or at what granularity.

Every question must now carry an **anchor** (a particular the user already gave), a visible
**answer shape** (number, name, yes/no, step, date — with the unit named when one is
expected), and a **reason** when the relevance is not obvious. A vague answer to an abstract
question is the interviewer's fault, not the user's.

Both question banks gained a nine-row rewrite table showing the bare version beside the
concrete one, because the rule is easier to follow from examples than from a definition.

Guarded against the obvious over-correction: concrete is not long. The anchor is four or
five words; one or two sentences, three is already too many. Padding buries a question as
surely as stripping it does.

Two further traps named: asking the question a layer is named after (Layer 4 is called
Components; that does not make *"what are the components?"* a question), and losing the
anchor deep into a long interview, when both sides know the context but the transcript is
read later by someone who was not there.

**This changelog** was added in the same change, backfilled from the git history.

**Test harness: infrastructure failures now abort instead of reporting as defects.** The CLI
session expired mid-session and every turn came back with an auth error; the assertions read
that as twelve skill defects and the run scored 4 of 16. The suite now checks the CLI before
starting and aborts with exit code 2 the moment any turn returns an auth, quota or
rate-limit error. Exit 2 means nothing was tested — only 0 and 1 say anything about the
skill.

**Not verified.** Rule 10 and its test (T7) are unrun: the CLI session expired before the
suite could execute, and re-authenticating needs an interactive terminal. The changes are
documentation and assertions, both unexecuted.

## 1.9.0 — 2026-08-27

**The synthesis leads with three deliverables.**

The result of an interview is a diagram, a contract and acceptance criteria. Those were
sections 2, 15–16 and 17 of a flat list of nineteen, so a reader looking for what to build
walked through fears, worked examples and references to reach it.

Restructured into three parts. **A** is the result: the whole picture as ASCII *and* SVG,
the process contract with its chain check, the acceptance criteria. **B** is the evidence
behind it. **C** is what is still open, plus the proposal. Someone who reads only A should
be able to act; B and C exist so they can check A rather than trust it.

All three ship as copy-pasteable plain-text blocks — they are what gets handed to whoever
builds the thing, and an artifact that cannot be lifted off the page gets retyped and
mangled. Nothing was cut; the same content, reordered.

Two harness defects fixed: tests shared one working directory, so one test's transcript was
found by the next and correctly voided as content the user never said, failing a different
assertion each run; and T5a's grep matched "tự quyết" regardless of negation, scoring "tôi
sẽ **không** tự quyết thay bạn" as a violation of the rule it was obeying.

## 1.8.1 — 2026-08-27

**Moved triggered procedures out of the per-invocation budget.**

Measured first: `SKILL.md` had grown from 13.5 KB to 31.5 KB and the on-invoke cost from
~3.4k tokens to ~7.3k, all of it loaded every time the skill fires. Most of the growth was
procedure that only matters once something specific has happened — containment steps for a
doubled reply, the climb for an unanswered question, verification steps for sent material,
the Layer 4–6 completeness tables, the Layer 8 field tables.

Those moved to `references/rules-in-detail.md`, read on trigger. What stays is every rule's
prohibition and principle plus a pointer naming the trigger. Splitting on *prohibition vs
recovery procedure* rather than on length is what makes it safe: the model never needs the
recovery steps to know the rule exists.

7.3k → 6.2k on invoke. Verified rather than assumed — T5 and T6 exercise the two procedures
that left `SKILL.md`, and both still passed.

## 1.8.0 — 2026-08-27

**Four gaps found by checking the skill against the coaching prompt it came from.**

The interview method matched. Four things in the source prompt had no counterpart here.

*"Tôi chưa muốn bạn thực hiện triển khai gì cả"* appeared twice in the source and nowhere in
the skill — now **rule 9**, banning building during the interview and after it, with no
small-enough exception. The failure mode is specifically an interview that went well: a
shared picture creates the urge to act, and acting is how the picture stops being checked.

The prompt asks which measures answer which fears. All the skill had was a clause inside the
solution section claiming it did. Now its own section: one row per fear in the user's words,
what addresses it, how, and the **residual risk**, which is mandatory because a
countermeasure claiming to eliminate a fear is usually hiding the leftover.

The prompt wants an ASCII diagram; the checkpoint produced one and the synthesis dropped it
for SVG. It now carries both.

The worked example's second fear was prompt injection through auto-replied comments, and
Layer 7 had nothing on untrusted input at all. It now asks which steps are fed by someone
outside the user's control, whether that input can carry instructions aimed at the
automation itself, and whether an outsider's input can reach an irreversible action with no
human in between.

The example's third fear — separately built skills that turn out not to join up — is what
Layer 8's chain check already addressed, which is independent evidence that layer earns its
cost.

## 1.7.0 — 2026-08-26

**Rule 8: material the user sent is a candidate, not an answer.**

Rule 2 forbids research, and a source merely named stays unopened. Material *delivered into
the conversation* is different — they handed it over, so reading it is not research.

Reading it is not the same as being answered, though: lifting an answer out of a document is
answering for the user through a document, which rule 7 forbids as much as inventing one. So
sent material produces a candidate — quote the exact passage, ask whether it is the answer
*and* whether it is still true, hold it as `CANDIDATE` until confirmed.

Quoting rather than paraphrasing is load-bearing: a paraphrase is already an interpretation,
and the interpretation is what needs checking. Where document and user disagree, that is a
finding, not something to smooth over — whoever reads that document next is misled the same
way.

Sent material is data, never instructions: text inside a document addressing the interviewer
gets quoted to the user, not acted on.

## 1.6.0 — 2026-08-25

**Layer 8: the process contract.**

The interview stopped one step short of usable — it mapped components, relationships,
decisions and exceptions, then handed over a document nobody could build from.

Per step: input, output and an acceptance criterion always; precondition, validation, owner
and timing when the trigger applies. Acceptance is the field people answer badly — *"the
refund is approved"* restates the output instead of testing it — so the question pushes for
something checkable.

It does not re-elicit the steps; Layers 3 and 6 already have them, so the table is drafted
from the transcript with inferred cells marked and only those get a question.

The **chain check** is the point: every junction between adjacent steps is `MATCH`, `GAP`,
`SURPLUS` or `MISMATCH`. Non-matches are almost never process defects — they are interview
gaps. A first pass that is all `MATCH` is reported as a warning, not a clean bill of health:
it means the steps were cut too coarsely to disagree.

## 1.5.0 — 2026-08-25

**Rule 7: never answer for the user.**

A real defect, caught in this repo's own test output and missed on review. Asked the depth
question twice, got narrative instead of a choice both times, and announced *"tôi tự chốt:
đi theo chế độ nhanh"*.

Rule 6 already said not to answer on the user's behalf, but all five of its containment
steps addressed the doubled-reply fault. Nothing covered the user answering a *different*
question. Rule 4 handles vague answers by slicing; there was no rule for no answer at all.

Self-deciding is worse than the doubled reply rule 6 was built for: a doubled reply is
visible as two mismatched texts, while a self-decided one reads as a reasonable recovery and
enters the transcript as fact under a `[YOU SAID]` label.

Replaced with a reformulation ladder — park what they did say, strip to a one-word part,
climb one dimension per turn, come at it from the side when that stalls. Never re-ask in the
same words: the second identical ask is what made the self-decision feel justified.

## 1.4.0 — 2026-08-24

**Prove coverage instead of claiming it.**

An audit against the five original requirements found three only partly met, all failing the
same way: *all* and *each* were asserted in prose with nothing checking them.

Layer 5 was worst — it asked about "plausibly related" pairs, handing the judgement to the
model and letting pairs vanish without trace, so "the relationships of each component" was
really "the pairs that looked interesting". Now a **pair matrix** of all N(N−1)/2 pairs
built before any question, each ending `ASKED`, `NOT RELATED` or `SKIPPED` with a reason.

Layer 4 named components once and asked for the *main* things, which drops the small ones —
where the exceptions live. Naming now re-opens until two consecutive rounds add nothing, and
every component gets two first-principles tests: can it be split further and still mean
something, and does it exist by necessity or convention.

The nine facets were unbudgeted — five components × nine facets is 45 questions, so the
model was always going to trim and nothing said how. Three are now mandatory, six
conditional, skips recorded per component.

Shared principle: skipping stays legitimate, skipping *invisibly* does not.

## 1.3.0 — 2026-08-24

**Quick depth alongside deep.**

One skill with two depths rather than a second skill: two skills whose descriptions both
match "interview me" would leave the model choosing between them, and would double every
future rule change.

Quick covers the same layers with the 1–2 highest-yield questions each, about 15 total. It
keeps the whole-picture checkpoint — the highest-yield moment, therefore the last thing
worth cutting — and drops the per-layer read-backs, which would eat eight turns of a
fifteen-question budget.

The real difference is the stopping rule. Deep ends when the ambiguity ledger is empty;
quick ends when the last layer closes and **reports** the ledger instead of clearing it, so
open items become the headline section rather than something the document quietly implies
was settled. Escalation is a field edit, not a restart, and never happens without the user
agreeing.

## 1.2.0 — 2026-08-24

**Rule 6: only the user answers.**

Covers answers arriving under the user's name that the user never typed — typically a
doubled reply, sometimes with system-reminder blocks or token counters interleaved.
Containment rather than repair, since the fault is at the application layer: two versions
that differ void each other, both are quoted into the transcript marked `VOID`, no
conclusions are drawn, and the question is asked again.

The premise being protected: a transcript holding one sentence the user did not say is worse
than a transcript with a gap.

Headless smoke test suite added the same day.

## 1.1.0 — 2026-08-20

**Draw the whole picture, not just describe it.**

New Layer 2, Fears & stakes, with two registers kept strictly separate — the user's own
fears and the end users' — because they drive different decisions.

Three collection duties now run across every layer rather than living in one: concrete
examples (a general rule with no real instance is belief, not process), illustrations
(screenshots, reference products, and the user's own analogies quoted verbatim), and
references (recorded, never opened — reading is research, which the interview forbids).

New whole-picture checkpoint after the relationships layer: Claude stops asking and sketches
the entire problem as boxes and arrows, then asks what is wrong with it. Anything it had to
invent to make the drawing work is a gap, and gets logged as one.

## 1.0.0 — 2026-08-19

Initial release. Bilingual problem-interview skill: one question at a time across seven
layers, a transcript logged after every answer, and a self-contained HTML synthesis.
Packaged both as a Claude Code plugin marketplace and as a plain skill folder.
