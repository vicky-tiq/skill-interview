# skill-interview

A Claude Code skill that interviews you about your problem before anything gets built.

**English** · [Tiếng Việt](#tiếng-việt)

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
| Questions | 40–70 | ~15, one pass |
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

A deep interview runs 40–70 questions, a quick one about 15. Output:

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

## Tiếng Việt

[English](#skill-interview) · **Tiếng Việt**

Skill phỏng vấn bóc tách bài toán, song ngữ (**English / Tiếng Việt**). Thay vì đoán ý
bạn từ một câu yêu cầu ngắn, Claude phỏng vấn bạn: **hỏi từng câu một**, qua tám tầng,
cho đến khi bức tranh tổng thể *vẽ ra được* chứ không phải đoán. Sau đó nó xuất một file
HTML tự chứa — mở đầu bằng sơ đồ tổng thể — để bạn đọc, soát lỗi và chia sẻ.

### Hai độ sâu

Câu hỏi đầu tiên chốt luôn ngôn ngữ và độ sâu.

| | **Sâu** | **Nhanh** |
|---|---|---|
| Số câu | 40–70 | ~15, một lượt |
| Mỗi tầng | Đào cạn | 1–2 câu sinh lời nhất |
| Sơ đồ tổng thể | Có | **Có** — không bao giờ cắt |
| Kết thúc khi | Không còn điểm mơ hồ | Hết tầng 7, còn mơ hồ cũng xong |
| Bản đúc kết | 15 mục | 9 mục |
| Điểm chưa rõ | Không được tồn tại | **Là kết quả chính** |

Cả hai đi hết tám tầng — bản nhanh nông hơn, không phải hẹp hơn. Nó không giả vờ đạt
mức chắc chắn mà nó chưa đạt: mọi thứ chưa xác lập được đi vào mục *"cần chốt gì trước
khi làm"* đặt ở vị trí nổi bật, mỗi dòng ghi rõ đoán sai thì vỡ ở đâu. Một bản nhanh
che lỗ hổng còn tệ hơn không phỏng vấn, vì nó biến phỏng đoán thành tài liệu.

Bản nhanh có thể chuyển thành sâu giữa buổi mà không mất gì — cùng định dạng biên bản,
nên nó tiếp tục ở tầng còn nhiều điểm mở nhất chứ không làm lại từ đầu. Nó **không bao
giờ tự nâng cấp**: trôi từ 15 câu lên 45 là phá vỡ thoả thuận bạn đã chọn ở câu đầu.

Gọi bằng `/interview` rồi chọn ở màn hỏi, hoặc nói thẳng *"phỏng vấn nhanh"* để vào
luôn chế độ nhanh.

### Tám tầng

| # | Tầng | Xác lập điều gì |
|---|---|---|
| 0 | Mục đích gốc & định nghĩa thành công | Rằng bạn đang giải đúng bài toán, và "xong" nghĩa là gì |
| 1 | Bối cảnh & ràng buộc | Ai liên quan; ràng buộc nào là luật cứng, cái nào chỉ là thói quen |
| 2 | Nỗi sợ & cái đang đặt cược | **Bạn** sợ gì, và riêng ra, **người dùng cuối** sợ gì |
| 3 | Hiện trạng vs mong muốn | Hôm nay đau ở đâu; đã thử gì và vì sao thất bại |
| 4 | Thành phần | Bóc theo tư duy nguyên bản thành các thứ nhỏ nhất còn có nghĩa |
| 5 | Quan hệ | Các thứ đó ràng buộc nhau thế nào; cái gì chảy giữa chúng |
| 6 | Logic nghiệp vụ | Từng điểm quyết định, từng nhánh, điều kiện và ngưỡng chính xác |
| 7 | Ngoại lệ & trường hợp biên | Nhánh lỗi, đồng thời, zero/một/rất nhiều, ai được phá luật |

Hai sổ nỗi sợ không bao giờ bị trộn. Nỗi sợ bị quy trách nhiệm của bạn và nỗi sợ mất
tiền của khách hàng là hai đầu vào khác nhau: cái thứ nhất định hình *không nên* làm gì,
cái thứ hai định hình nên làm gì.

### Thu thập xuyên suốt, không thuộc tầng nào

- **Ví dụ cụ thể** — ngay khi bạn mô tả một quy luật chung ("đơn lớn thường..."), nó xin
  một ca thật với con số thật. Quy luật không có ca thật đằng sau là quy luật bạn *tin*,
  không phải quy luật đang *chạy*.
- **Minh hoạ** — khi có thứ khó diễn đạt bằng lời, nó thôi đòi văn xuôi và xin ảnh chụp,
  một sản phẩm đã làm đúng kiểu đó, hoặc một ẩn dụ. Ẩn dụ của bạn được trích nguyên văn,
  vì nó mang cấu trúc mà văn xuôi của bạn không mang.
- **Nguồn tham khảo** — mọi tài liệu, link, đối thủ hay người bạn nhắc tới đều được ghi
  lại: là cái gì, ở đâu, vì sao quan trọng. **Ghi nhận, không đọc** — xem mục dưới.

### Chốt bức tranh tổng thể

Giữa buổi — sau tầng quan hệ, trước logic nghiệp vụ — Claude dừng hỏi và **vẽ**. Nó
phác cả bài toán thành sơ đồ hộp-và-mũi-tên ngay trong chat, rồi hỏi đúng một câu: nó
sai chỗ nào, và thiếu gì?

Đây là thời điểm sinh lời nhất của buổi phỏng vấn. Vẽ sai thì sửa trong vài giây; cùng
lỗi đó nằm vùi trong văn xuôi thì sống tới cuối buổi. Và thứ gì Claude phải bịa ra để
bản vẽ liền mạch chính là một lỗ hổng, và bị đánh dấu là lỗ hổng.

### Cách nó hoạt động

- **Một câu một lượt.** Không câu ghép, không bắt bạn trả lời một loạt.
- **Không tự nghiên cứu.** Không đọc code, không tra web, không đoán từ file có sẵn — để
  không nhầm giả định của nó thành yêu cầu của bạn. Nguồn bạn đưa thì nó *ghi nhận, không
  mở ra đọc*, nên không có gì trong bản đúc kết được trình bày như đã kiểm chứng khi chưa.
- **Trả lời "chưa biết" cũng được.** Nó chẻ câu hỏi nhỏ hơn theo thang bảy bậc — từ tổng
  quát, xuống một ca cụ thể, xuống một lựa chọn nhị phân — thay vì bỏ qua.
- **Chỉ bạn trả lời.** Nó không bao giờ viết hộ, viết thêm, hay "làm gọn" câu trả lời của
  bạn. Nếu một câu trả lời hiện ra hai lần với nội dung khác nhau — lỗi tầng ứng dụng, có
  xảy ra — cả hai bản bị huỷ và câu hỏi được hỏi lại. Một biên bản chứa một câu bạn không
  nói còn tệ hơn một biên bản bị thiếu.
- **Có sổ mơ hồ.** Buổi phỏng vấn chỉ kết thúc khi sổ sạch, hoặc khi bạn nói "đủ rồi".
- **Ghi biên bản sau từng câu**, nên dừng giữa buổi không mất gì. Chạy lại là nối tiếp
  đúng câu, đúng ngôn ngữ, đúng độ sâu.

### Đọc bản đúc kết

Mỗi mệnh đề trong file HTML mang một trong ba nhãn:

| Nhãn | Nghĩa |
|---|---|
| `[BẠN NÓI]` | Trích từ chính lời bạn |
| `[TÔI SUY RA]` | Claude nối các mảnh lại; bạn chưa từng xác nhận |
| `[TÔI ĐỀ XUẤT]` | Ý của Claude — chỉ có ở phần giải pháp |

**Đọc `[TÔI SUY RA]` trước.** Chỗ hiểu sai nằm ở đó, và việc tách ba nhãn này chính là
toàn bộ cơ chế bắt lỗi của skill.

### Cài đặt

**Cách A — cài như plugin (khuyến nghị, cập nhật gọn).** Trong Claude Code:

```
/plugin marketplace add vicky-tiq/skill-interview
/plugin install interview@skill-interview
```

**Cách B — copy thư mục skill:**

```bash
git clone https://github.com/vicky-tiq/skill-interview.git
mkdir -p ~/.claude/skills
cp -R skill-interview/skills/interview ~/.claude/skills/
```

Hoặc symlink thay vì copy, để `git pull` là tự có bản mới:

```bash
ln -sfn "$PWD/skill-interview/skills/interview" ~/.claude/skills/interview
```

**Cách C — theo từng dự án.** Copy `skills/interview` vào `.claude/skills/` của một repo
rồi commit. Ai clone repo đó là có skill, không cần cài gì.

### Dùng thế nào

```
/interview
```

Kèm luôn bài toán cũng được: `/interview quy trình hoàn tiền của mình đang rất chậm`

Câu hỏi đầu tiên là chọn ngôn ngữ và độ sâu. Sau đó mọi thứ giữ nguyên ngôn ngữ đó:
câu hỏi, biên bản, và file HTML.

Bản sâu chạy 40–70 câu, bản nhanh tầm 15 câu. Kết quả:

```
interview/<ten-bai-toan>/transcript.md     # toàn bộ hỏi–đáp, nguyên văn
interview/<ten-bai-toan>/synthesis.html    # bản đúc kết để đọc và chia sẻ
```

> **Lưu ý:** hai file đó được ghi vào **thư mục làm việc hiện tại**. Nếu bạn chạy trong
> repo công ty, thêm `interview/` vào `.gitignore` của repo đó — nội dung phỏng vấn
> thường là thông tin nội bộ, không nên commit.

### Trong repo có gì

```
skills/interview/
├── SKILL.md                       # quy trình và các luật
└── references/
    ├── question-bank-en.md        # ~140 câu mồi, tiếng Anh, kèm danh sách 15 câu bản nhanh
    ├── question-bank-vi.md        # ~140 câu mồi, tiếng Việt, kèm danh sách 15 câu bản nhanh
    ├── terminology.md             # đối chiếu EN↔VI: nhãn, sổ mơ hồ, tiêu đề mục
    ├── transcript-template.md     # cấu trúc biên bản và các sổ thu thập
    └── html-template.md           # cấu trúc bản đúc kết 15 mục / 9 mục
```

Toàn bộ là markdown, không code, không phụ thuộc, không gọi mạng.

---

## License

MIT — see [LICENSE](LICENSE).
