# skill-interview

A Claude Code skill that interviews you about your problem before anything gets built.

---

## `interview` — understand the problem before building it

A bilingual (**English / Tiếng Việt**) interview skill. Instead of guessing at your
intent from a one-line request, Claude interviews you: **one question at a time**,
across eight layers, until the whole picture can be *drawn* rather than guessed. Then it
writes a single self-contained HTML file — overview diagram first — that you can read,
correct, and share.

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

A full interview runs 40–70 questions. Output:

```
interview/<problem-slug>/transcript.md     # the full Q&A log, verbatim
interview/<problem-slug>/synthesis.html    # the readable, shareable synthesis
```

> **Note:** those files are written to your **current working directory**. If you run
> this inside a work repo, add `interview/` to that repo's `.gitignore` — interview
> content is usually internal information you don't want committed.

---

## Tiếng Việt

Skill phỏng vấn bóc tách bài toán. Thay vì đoán ý bạn từ một câu yêu cầu ngắn, Claude
phỏng vấn bạn: **hỏi từng câu một**, theo 7 tầng, cho đến khi không còn điểm mơ hồ.
Sau đó xuất một file HTML tự chứa để bạn đọc, soát lỗi và chia sẻ.

Mục đích không phải là tài liệu. Mục đích là bắt được chỗ hiểu sai **trước khi** nó
biến thành một tuần code sai hướng.

**Tám tầng:** mục đích gốc & định nghĩa thành công → bối cảnh & ràng buộc → **nỗi sợ &
cái đang đặt cược** → hiện trạng vs mong muốn → thành phần → quan hệ → logic nghiệp vụ
(cây quyết định) → ngoại lệ & trường hợp biên.

Nỗi sợ được tách làm hai sổ riêng, không trộn: nỗi sợ của **bạn** (sợ làm sai hướng, sợ
ai phản ứng) và nỗi sợ của **người dùng cuối** (sợ mất gì, ngại gì, lý do không nói ra).
Hai thứ đó dẫn tới hai loại quyết định khác nhau.

**Thu thập xuyên suốt, không thuộc tầng nào:** ví dụ cụ thể (ca thật, số thật — quy luật
không có ca thật là quy luật bạn *tin*, không phải quy luật đang *chạy*), minh hoạ (ảnh,
sản phẩm mẫu, ẩn dụ của chính bạn — trích nguyên văn), và nguồn tham khảo (**ghi nhận,
không đọc**).

**Chốt bức tranh tổng thể:** giữa buổi, Claude dừng hỏi và **vẽ** — sơ đồ hộp-và-mũi-tên
cả bài toán, rồi hỏi đúng một câu: nó sai chỗ nào, thiếu gì? Đây là thời điểm bắt lỗi
hiệu quả nhất: vẽ sai thì sửa trong vài giây, còn cùng lỗi đó nằm trong văn xuôi thì sống
đến cuối buổi.

**Cách nó hoạt động:**

- **Một câu một lượt.** Không hỏi gộp, không bắt bạn trả lời một loạt.
- **Không tự nghiên cứu.** Không đọc code, không tra web, không đoán từ file có sẵn —
  để không nhầm giả định của nó thành yêu cầu của bạn.
- **Trả lời "chưa biết" cũng được.** Nó chẻ câu hỏi nhỏ hơn theo thang 7 bậc thay vì
  bỏ qua.
- **Có sổ mơ hồ.** Chỉ kết thúc khi sổ trống, hoặc khi bạn nói "đủ rồi".
- **Ghi biên bản sau từng câu**, nên nghỉ giữa buổi không mất gì. Chạy lại là nối tiếp
  đúng câu, đúng ngôn ngữ.

**Đọc bản đúc kết:** mỗi mệnh đề có nhãn `[BẠN NÓI]` / `[TÔI SUY RA]` / `[TÔI ĐỀ XUẤT]`.
Đọc `[TÔI SUY RA]` trước — chỗ hiểu sai gần như luôn nằm ở đó. File HTML mở đầu bằng
**sơ đồ tổng thể**: nhìn riêng phần đó là kể lại được cả bài toán.

Cài đặt: xem phần **Install** ở trên. Gõ `/interview` để bắt đầu; câu đầu tiên là chọn
ngôn ngữ.

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

## License

MIT — see [LICENSE](LICENSE).
