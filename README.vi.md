# skill-interview

[English](README.md) · **Tiếng Việt**

## `interview` — hiểu bài toán trước khi xây nó

Skill phỏng vấn bóc tách bài toán, song ngữ (**English / Tiếng Việt**). Thay vì đoán ý
bạn từ một câu yêu cầu ngắn, Claude phỏng vấn bạn: **hỏi từng câu một**, qua chín tầng,
cho đến khi bức tranh tổng thể *vẽ ra được* chứ không phải đoán. Sau đó nó xuất một file
HTML tự chứa — mở đầu bằng sơ đồ tổng thể — để bạn đọc, soát lỗi và chia sẻ.

### Hai độ sâu

Câu hỏi đầu tiên chốt luôn ngôn ngữ và độ sâu.

| | **Sâu** | **Nhanh** |
|---|---|---|
| Số câu | 65–100 | ~15, một lượt |
| Mỗi tầng | Đào cạn | 1–2 câu sinh lời nhất |
| Sơ đồ tổng thể | Có | **Có** — không bao giờ cắt |
| Kết thúc khi | Không còn điểm mơ hồ | Hết tầng 7, còn mơ hồ cũng xong |
| Bản đúc kết | 18 mục | 10 mục |
| Điểm chưa rõ | Không được tồn tại | **Là kết quả chính** |

Cả hai đi hết chín tầng — bản nhanh nông hơn, không phải hẹp hơn. Nó không giả vờ đạt
mức chắc chắn mà nó chưa đạt: mọi thứ chưa xác lập được đi vào mục *"cần chốt gì trước
khi làm"* đặt ở vị trí nổi bật, mỗi dòng ghi rõ đoán sai thì vỡ ở đâu. Một bản nhanh
che lỗ hổng còn tệ hơn không phỏng vấn, vì nó biến phỏng đoán thành tài liệu.

Bản nhanh có thể chuyển thành sâu giữa buổi mà không mất gì — cùng định dạng biên bản,
nên nó tiếp tục ở tầng còn nhiều điểm mở nhất chứ không làm lại từ đầu. Nó **không bao
giờ tự nâng cấp**: trôi từ 15 câu lên 45 là phá vỡ thoả thuận bạn đã chọn ở câu đầu.

Gọi bằng `/interview` rồi chọn ở màn hỏi, hoặc nói thẳng *"phỏng vấn nhanh"* để vào
luôn chế độ nhanh.

### Chín tầng

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
| 8 | Cam kết quy trình | Các bước kèm đầu vào, đầu ra, xác thực và nghiệm thu — và chúng có khớp nối hay không |

Hai sổ nỗi sợ không bao giờ bị trộn. Nỗi sợ bị quy trách nhiệm của bạn và nỗi sợ mất
tiền của khách hàng là hai đầu vào khác nhau: cái thứ nhất định hình *không nên* làm gì,
cái thứ hai định hình nên làm gì.

### Tầng cuối: nó có khớp nối được không?

Tầng 8 biến mọi thứ ở trên thành thứ làm được: một danh sách bước có thứ tự, mỗi bước ghi rõ nhận vào gì, trao ra gì, kiểm xác thực gì, và phép kiểm quan sát được nào nói rằng bước đó đã làm **đúng**, không phải chỉ là đã làm. Chỗ cuối là chỗ người ta hay trả lời sai: "đơn đã được duyệt" chỉ là nhắc lại đầu ra, không phải một phép kiểm.

Nó **không hỏi lại các bước từ đầu.** Tầng 3 và Tầng 6 đã đi qua quy trình và đã vẽ các điểm quyết định, nên bảng được dựng từ biên bản, ô nào phải suy ra thì đánh dấu, và chỉ những ô đó mới được hỏi. Tầng này tốn theo phần còn thiếu, không tốn theo số bước.

Rồi tới **phép kiểm khớp nối**, chính là lý do tầng này tồn tại. Mỗi mối nối giữa hai bước liền nhau được so và đánh `KHỚP`, `THIẾU` (bước sau cần thứ không bước nào tạo ra), `THỪA` (có thứ được tạo ra mà không ai dùng), hoặc `LỆCH` (cả hai đều có nhưng khác hình dạng, đơn vị, hoặc thời điểm). Chỗ không khớp gần như không bao giờ là lỗi của quy trình — nó là lỗ hổng của buổi phỏng vấn, và mỗi chỗ thành một câu hỏi. `THỪA` thường lộ ra một bên tiêu thụ chưa ai gọi tên, tức phải quay lại Tầng 4.

Lượt đầu mà mọi mối nối đều `KHỚP` là dấu hiệu đáng lo, không phải thành công: nó nghĩa là các bước được mô tả quá thô nên không thể lệch nhau.

### Chứng minh độ phủ, không cho là đã phủ

Bản sâu có một bộ máy mà việc duy nhất của nó là **làm chỗ bỏ sót hiện ra**. "Tất cả thành phần" và "từng quan hệ" là lời tuyên bố, mà tuyên bố không được kiểm chính là cách một buổi phỏng vấn có cảm giác kỹ lưỡng nhưng vẫn để lỗ.

- **Thành phần được gọi tên tới khi cạn** — câu gọi tên mở lại cho tới khi hai lượt liền không thêm được gì mới. Không bao giờ gọi chúng là những thứ "chính", vì cách nói đó loại các thứ nhỏ, mà các thứ nhỏ mới là nơi ngoại lệ ẩn.
- **Hai phép thử nguyên bản chạy trên mọi thành phần** — chẻ nhỏ hơn nữa mà vẫn có nghĩa được không, và nó tồn tại vì tất yếu hay chỉ vì lâu nay vẫn làm vậy. Không có phép thử thứ nhất thì "nhỏ nhất mà vẫn có nghĩa" chỉ là cái nhãn.
- **Khía cạnh có ngân sách và chỗ bỏ được ghi lại** — ba trong chín khía cạnh luôn hỏi, phần còn lại chỉ khi trọng yếu, và bỏ cái nào thì ghi lại theo từng thành phần. Thành phần phủ mỏng phải trông mỏng, không được trông như đã xong.
- **Quan hệ dùng ma trận cặp** — cả N(N−1)/2 cặp được ghi vào biên bản trước khi hỏi câu nào, mỗi cặp kết thúc ở `ĐÃ HỎI`, `KHÔNG LIÊN QUAN`, hoặc `ĐÃ BỎ` kèm lý do. Bỏ một cặp vẫn hợp lệ; bỏ **mà không ai thấy** thì không.
- **Điểm quyết định cũng liệt kê tới khi cạn**, và ghi danh sách trước khi đi vào từng điểm.

Bản nhanh không chạy bộ máy này — dựng ma trận cặp trên ngân sách 15 câu là phá luôn ý nghĩa của chữ "nhanh".

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
- **Nó cũng không được quyết thay bạn.** Nếu bạn không trả lời một câu — vì muốn kể chuyện
  khác, hoặc thấy câu đó không quan trọng — nó không được tự điền câu trả lời, kể cả dưới
  dạng "mặc định". Nó phải hỏi lại cách khác: ghi nhận và gác lại phần bạn đã kể, rồi chẻ
  câu hỏi thành phần và hỏi phần đơn giản nhất trước, sau đó leo dần lên. Hỏi lại nguyên
  văn bị cấm, vì lần hỏi lại y hệt chính là bước làm cho việc tự quyết trông có lý.
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

## Cài đặt

### Cách A — cài như plugin (khuyến nghị, cập nhật gọn)

Trong Claude Code:

```
/plugin marketplace add vicky-tiq/skill-interview
/plugin install interview@skill-interview
```

### Cách B — copy thư mục skill

```bash
git clone https://github.com/vicky-tiq/skill-interview.git
mkdir -p ~/.claude/skills
cp -R skill-interview/skills/interview ~/.claude/skills/
```

Hoặc symlink thay vì copy, để `git pull` là tự có bản mới:

```bash
ln -sfn "$PWD/skill-interview/skills/interview" ~/.claude/skills/interview
```

### Cách C — theo từng dự án

Copy `skills/interview` vào `.claude/skills/` của một repo
rồi commit. Ai clone repo đó là có skill, không cần cài gì.

## Dùng thế nào

```
/interview
```

Kèm luôn bài toán cũng được: `/interview quy trình hoàn tiền của mình đang rất chậm`

Câu hỏi đầu tiên là chọn ngôn ngữ và độ sâu. Sau đó mọi thứ giữ nguyên ngôn ngữ đó:
câu hỏi, biên bản, và file HTML.

Bản sâu chạy 65–100 câu, bản nhanh tầm 15 câu. Kết quả:

```
interview/<ten-bai-toan>/transcript.md     # toàn bộ hỏi–đáp, nguyên văn
interview/<ten-bai-toan>/synthesis.html    # bản đúc kết để đọc và chia sẻ
```

> **Lưu ý:** hai file đó được ghi vào **thư mục làm việc hiện tại**. Nếu bạn chạy trong
> repo công ty, thêm `interview/` vào `.gitignore` của repo đó — nội dung phỏng vấn
> thường là thông tin nội bộ, không nên commit.

## Trong repo có gì

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

## Giấy phép

MIT — xem [LICENSE](LICENSE).
