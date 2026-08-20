# Seed question bank — 8 layers (English)

These are **prompts, not a form**. Real questions must grow out of the previous answer, reusing the user's exact vocabulary. The one-question-per-turn rule still applies.

---

## Question-slicing ladder (use when an answer is vague or "I don't know")

Slice one rung at a time, in this order:

1. **General → one concrete instance** — "Take the single most recent time this happened: walk me through that day."
2. **Instance → one step** — "In that case, for the submit-the-paperwork step specifically, who did it?"
3. **Open → binary** — "Does that step require a human approver: yes or no?"
4. **Binary → forced comparison** — "If you had to pick: slow but correct, or fast with some risk of being wrong?"
5. **Positive → negative** — "Forget what it should be. What must it *not* be?"
6. **Current → extreme** — "If volume were 10× tomorrow, what breaks first?"
7. **Role reversal** — "If I got this part wrong, who complains first, and what do they say?"

If rung 7 still yields nothing: log it in the Ambiguity Ledger as **GENUINELY UNKNOWN**, state what it affects, and move on.

---

## Layer 0 — Root purpose & definition of success

- What's the problem you want me to understand? Just talk it through — it doesn't need to be organized.
- If this problem never gets solved, what's worse six months from now?
- Why **now**? What changed that made this a must-do?
- Who actually feels the pain — you, your staff, your customers, someone else?
- Is this a problem you're facing, or a solution you've already designed for a different problem? (If a solution → trace back up to the root problem.)
- Once it's solved, what will you look at to know it's solved? Something observable.
- Is there a number attached to that signal? From what level to what level?
- What's the smallest version that would still be worth doing?
- What could happen that would make you call this a **failure**, even if everything technically works?
- (5 Whys) Why does that matter to you? — repeat until you reach the real root.

## Layer 1 — Context & constraints

- Who are the people involved? Name them one group at a time.
- Of those, who makes the **final call**?
- Who might push back, and what would they be pushing back against?
- Is there a deadline? Where did that date come from — a commitment to someone, or self-imposed?
- Resources on hand: how many people, how many hours a week, which tools are already paid for?
- What is **not allowed to change**? (legacy systems, contracts, regulations, people, habits)
- For each constraint you just named: is it a hard rule, or just how it's currently done?
- Has anyone ever tried breaking that constraint? What happened?
- If this goes wrong, what's the worst consequence — money, customers, data, or reputation?
- Any regulatory, compliance, or legal requirements governing this?

## Layer 2 — Fears & stakes

Two registers, kept strictly separate. Ask the user's own fears first, then switch and ask about the end users'. Never blend them into one question.

### The user's own fears

- What are you most afraid of getting wrong here?
- What would make you regret having started this at all?
- If this goes badly, who notices first, and what do they say to you?
- What's the failure you'd find hardest to explain to someone else?
- Is there a version of "success" that you'd still be uneasy about? Why?
- What are you afraid this will turn into six months from now?
- What are you quietly worried you don't understand well enough yet?
- Is there anyone whose reaction you're bracing for? What are they going to say?
- What's the part you keep putting off? What makes it unappealing?
- If you had to protect exactly one thing from being broken by this, what would it be?

### The end users' fears

("End users" = whoever actually lives with the result: customers, staff, partners.)

- Who has to change how they work because of this?
- What are they afraid of losing — time, control, status, income, their job?
- What's the reason they'd give for not adopting it, out loud?
- And the reason they wouldn't say out loud?
- What did they complain about last time something changed for them?
- What would make someone quietly go back to the old way?
- Who benefits least from this? What do they get out of cooperating?
- What's the worst thing that could happen to a customer because of this?
- If they only trusted one part of this, which part would it be?
- What would they need to see, in the first week, to believe it's better?

## Layer 3 — Current vs desired state

- How does this work today? Walk me through it step by step — starting from what moment?
- Which step eats the most time?
- Which step goes wrong most often?
- Who's carrying the manual work? How long per instance, how many times a week?
- Where does the data live today — files, a system, or in someone's head?
- What have you already tried? Why didn't it work? (Dig into each attempt separately.)
- Is there an approach you **deliberately ruled out**? Why?
- Describe a typical workday after this problem is solved — concretely, like a scene in a film.
- In that desired state, what work **no longer needs to happen**?
- Is anyone already doing what you want? How do they do it?

## Layer 4 — Components (first principles)

Goal: decompose the problem into the smallest "things" that are still meaningful on their own.

- In what you've described, what are the main **things** everything else revolves around? Just name them; no explanation yet.
- Then ask about **each one separately**, one facet per turn:
  - Define it in one sentence, the way you'd explain it to a new hire.
  - Where does it **come into existence**, and who or what creates it?
  - When does it **end** — does it disappear, close, or live forever?
  - What **states** can it be in? List them all, including the bad ones.
  - What has to be true to move it from state A to state B?
  - Which attributes are **mandatory** for it to count as existing at all?
  - Who **owns** it — who can edit it, who can only view it?
  - What **unit** is it measured in?
  - Does it have an **identity** — what makes two of them different?
- Term-definition question (ask one word at a time, never bundled): "When you say *<term>*, what exactly does it include, and what does it exclude?"
- Is anything on this list actually **two things fused** into one?
- Are any two of these actually **one thing** under two names?
- Is anything here not an independent thing at all, but really an **attribute** of something else?
- Is there anything that exists in your head but hasn't been named yet?

## Layer 5 — Relationships between components

Ask **pair by pair** for plausibly related pairs. Never ask in the abstract.

- Are A and B related? If so, describe it in one sentence with a verb in it.
- How many B's per A, and how many A's per B?
- Is that relationship **mandatory** or **optional** — can you have an A with no B?
- Which one must exist **first**?
- If you **delete A**, what happens to B — deleted too, orphaned, or untouched?
- What **flows** between A and B: data, money, goods, permissions, or just information?
- One direction or both? Who initiates the flow?
- When A and B **disagree**, which one is the source of truth?
- Are there any dependency cycles — A needs B, B needs C, C needs A?
- If A changes, what has to change with it? (change propagation)
- Is any of these relationships currently held **in someone's memory** rather than recorded in a system?

## Layer 6 — Business logic as decision trees

List the **decision points** in the flow, then exhaust them one at a time — every branch of this one before moving to the next.

For each decision point:
- At this step, who or what makes the decision?
- What does that person/system need to **know** in order to decide?
- Where does that information come from? Is it always available?
- How many **branches** lead out of here? Name each one.
- Beyond those branches, is there one for "doesn't fit any category"?
- What's the exact condition for this branch — which number, threshold, or date?
- Where did that threshold come from? Does it ever change, and who can change it?
- Which branch is the **default** when nothing can be determined?
- If two conditions are true at once, which one wins?
- After taking this branch, which component's **state** changes? From what to what?
- Does anyone get notified? Who?
- Is this decision **reversible**? By whom, within what window, needing whose approval?
- Is this step ever **skipped**? Under what circumstances, and who authorizes that?
- How long does this step take? What happens if it takes too long?

## Layer 7 — Exceptions & edge cases

- At each step: what can **go wrong**? (Ask one step at a time.)
- When it goes wrong, what does the system or person do — halt, retry, or continue?
- Who gets to know it went wrong?
- **Zero:** what happens when there's no data, no records at all?
- **One:** exactly one of something — does anything behave differently?
- **Many:** thousands at once — then what?
- **Concurrency:** two people edit the same thing at the same moment — who wins?
- **Duplicates:** the same thing enters the system twice — what detects it?
- **Missing data:** a mandatory field is empty — then what?
- **Stale data:** how old is too old to use?
- **Out-of-order time:** something that happened later gets recorded first — then what?
- Who is allowed to **break the rules**? Whose approval do they need? Is it recorded?
- What case have you actually hit in real life that the process doesn't cover?
- If volume grew 10×, what **breaks first**?
- If the person carrying this work quit tomorrow, what grinds to a halt?

---

## The three collection duties — question patterns

Fire these in any layer, the moment the trigger appears. One question each, never bundled.

### A. Concrete examples — trigger: a general pattern with no instance

- "Give me one real case. When did it last happen?"
- "Walk me through that specific one, start to finish."
- "What were the actual numbers on that one?"
- "Was that typical, or was it unusual? What would typical look like?"
- "How many times has that happened in the last month?"
- "Who was involved by name — or by role, if you'd rather?"

### B. Illustrations — trigger: something hard to say in words

- "Is there a screenshot, a photo, or a file that shows this?"
- "Is there a product or tool that already does this the way you want? Which part of it?"
- "What is this like? Give me an analogy, even a rough one."
- "If you were drawing this on a whiteboard, what would you draw first?"
- "Would it be easier to show me an example of what you *don't* want?"

### C. References — trigger: anything cited from outside this conversation

- "Where does that document live, and who owns it?"
- "Can you point me at it — a link or a path is enough?"
- "Who knows more about this part than you do?"
- "Is that written down anywhere, or is it just how it's done?"
- "Which competitor or company are you thinking of there?"
- "Is there a rule, contract, or policy behind that? Where?"

Record references — do not go read them. Reading is research, and research during the interview is forbidden.
