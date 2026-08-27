#!/usr/bin/env bash
# Headless smoke tests for the `interview` skill.
#
# By default tests the PUBLISHED artifact: installs the plugin from GitHub into a
# throwaway config dir, so nothing on your machine is touched and the working
# tree is not what gets tested.
#
# Usage:  tests/run-tests.sh [--local] [--keep]
#   --local  test the working tree via --plugin-dir instead of the GitHub release
#   --keep   leave the sandbox in place for inspection
#
# Requires: claude CLI. Costs ~5 API turns per run.
#
# CLI GOTCHA baked in below: --disallowedTools is variadic, so it eats any
# argument that follows it, including the prompt. The prompt must come first and
# the variadic flag must come last, or claude exits with "Input must be provided"
# and every assertion silently sees an empty string.

set -uo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
MARKETPLACE="vicky-tiq/skill-interview"
SID="$(uuidgen | tr "[:upper:]" "[:lower:]")"   # fresh per run; a fixed id resumes the last run
LOCAL=0; KEEP=0
for a in "$@"; do case "$a" in --local) LOCAL=1;; --keep) KEEP=1;; esac; done

SB="$(mktemp -d)"; CFG="$SB/config"; WORK="$SB/work"; mkdir -p "$CFG" "$WORK"
# NOTE: CLAUDE_CONFIG_DIR isolation is used for the plugin *install* check only.
# `claude -p` needs the real config for auth — an isolated config returns an empty
# reply, which silently zeroes every assertion.
cleanup(){ if [ "$KEEP" = 1 ]; then echo "sandbox kept: $SB"; else rm -rf "$SB"; fi; }
trap cleanup EXIT

PASS=0; FAIL=0
ok(){  printf '  \033[32mPASS\033[0m  %s\n' "$1"; PASS=$((PASS+1)); }
bad(){ printf '  \033[31mFAIL\033[0m  %s\n     → %s\n' "$1" "$2"; FAIL=$((FAIL+1)); }

# Flags that must sit AFTER the prompt; the variadic one is last on purpose.
# AskUserQuestion cannot be answered headlessly, so it is disabled and the skill
# falls back to plain-text questions — which is what the assertions read.
POST=(--strict-mcp-config --permission-mode acceptEdits)
if [ "$LOCAL" = 1 ]; then
  POST+=(--plugin-dir "$REPO_ROOT" --add-dir "$REPO_ROOT")
  echo "▸ target: working tree ($REPO_ROOT)"
else
  echo "▸ target: published plugin ($MARKETPLACE)"
  CLAUDE_CONFIG_DIR="$CFG" claude plugin marketplace add "$MARKETPLACE" >/dev/null 2>&1 \
    || { echo "  setup failed: marketplace add"; exit 1; }
  CLAUDE_CONFIG_DIR="$CFG" claude plugin install interview@skill-interview >/dev/null 2>&1 \
    || { echo "  setup failed: plugin install"; exit 1; }
  # Point at the installed version dir — the one that actually holds .claude-plugin.
  PDIR="$(dirname "$(find "$CFG/plugins/cache" -type d -name ".claude-plugin" | head -1)")"
  [ -n "$PDIR" ] && [ -f "$PDIR/.claude-plugin/plugin.json" ] \
    || { echo "  setup failed: installed plugin manifest not found under $CFG/plugins/cache"; exit 1; }
  echo "  installed at: ${PDIR#$CFG/}"
  POST+=(--plugin-dir "$PDIR" --add-dir "$PDIR")
fi
POST+=(--disallowedTools AskUserQuestion WebSearch WebFetch)

# Each test gets its own working directory. Sharing one lets interviews cross-contaminate:
# a transcript written by one test is found by the next, and the skill correctly flags it as
# content the user never said — which fails a different assertion on every run. Three runs,
# three different reds, all from this.
WORKN=0
newwork(){ WORKN=$((WORKN+1)); WORK="$SB/work$WORKN"; mkdir -p "$WORK"; }

# run <prompt> [session flags...]   — prompt first, variadic last
# Deliberately does NOT set CLAUDE_CONFIG_DIR: `claude -p` authenticates from the
# real config, and an isolated one yields a useless reply that zeroes assertions.
run(){ local p="$1"; shift; local n=$((++TURN))
       ( cd "$WORK" && claude -p "$p" "$@" "${POST[@]}" </dev/null 2>&1 ) | tee "$SB/turn$n.txt"; }
TURN=0

# An empty or errored reply must never satisfy an assertion.
sane(){ local out="$1" label="$2"
  if [ -z "$(printf %s "$out" | tr -d "[:space:]")" ]; then bad "$label" "empty reply from claude -p"; return 1; fi
  if printf '%s' "$out" | grep -qE '^Error:|Input must be provided'; then
    bad "$label" "claude -p errored: $(printf '%s' "$out" | head -1)"; return 1; fi
  return 0; }
# Never debug blind: on any failure, the raw replies are on disk.
dump(){ echo; echo "raw replies for inspection:"; for f in "$SB"/turn*.txt; do
          [ -f "$f" ] && { echo "--- $(basename "$f") (first 12 lines)"; head -12 "$f"; }; done; }
qmarks(){ printf '%s' "$1" | tr -cd '?' | wc -c | tr -d ' '; }

newwork
PROBLEM="quy trình duyệt hoàn tiền của công ty tôi đang rất chậm, khách phàn nàn nhiều"

echo; echo "T1/T2 — first turn: asks language, exactly one question"
OUT1="$(run "/interview $PROBLEM" --session-id "$SID")"
if sane "$OUT1" "T1 language choice offered first"; then
  if printf '%s' "$OUT1" | grep -qiE 'ti(ế|e)ng vi(ệ|e)t' \
  && printf '%s' "$OUT1" | grep -qiE 'english'; then
    ok "T1 language choice offered first"
  else
    bad "T1 language choice offered first" "no English/Tiếng Việt choice in first reply"
  fi
  if printf '%s' "$OUT1" | grep -qiE 'nhanh|quick' && printf '%s' "$OUT1" | grep -qiE 's(â|a)u|deep'; then
    ok "T1b depth choice offered alongside language"
  else
    bad "T1b depth choice offered alongside language" "Step 0 did not offer deep vs quick"
  fi
  # Step 0 is bilingual on purpose: one question, printed in both languages.
  Q1="$(qmarks "$OUT1")"
  if [ "$Q1" -ge 1 ] && [ "$Q1" -le 2 ]; then
    ok "T2a one question on turn 1 (bilingual, $Q1 marks)"
  else
    bad "T2a one question on turn 1" "found $Q1 question marks, expected 1-2"
  fi
fi

echo; echo "T1c — skill can read its own reference files"
if printf '%s' "$OUT1" | grep -qiE 'ch(ư|u)a (đ|d)(ọ|o)c (đ|d)(ư|u)(ợ|o)c|cannot read|outside .* working director|not permitted to read'; then
  bad "T1c reference files reachable" "skill reported it could not read references/ — it will run without the seed question banks"
else
  ok "T1c no read-permission complaint about references/"
fi

echo; echo "T2b — second turn stays at one question"
OUT2="$(run "Tiếng Việt, sâu" --resume "$SID")"   # Step 0 wants both; answering half makes it re-ask
if sane "$OUT2" "T2b exactly one question on turn 2"; then
  # "?" count is a crude proxy for question count. A single question can carry a second
  # mark when the turn quotes something back (rule 6 containment, rule 8 verification).
  # What must never happen is a silent turn (0 = the interview stalled) or a genuine
  # second question (3+). Strict exactly-one checks live in T2d/T6c, on clean fixtures.
  Q2="$(qmarks "$OUT2")"
  if [ "$Q2" -ge 1 ] && [ "$Q2" -le 2 ]; then
    ok "T2b one question on turn 2 ($Q2 marks)"
  else
    bad "T2b one question on turn 2" "found $Q2 question marks — 0 means the turn asked nothing, 3+ means it bundled"
  fi
fi

newwork
echo; echo "T2c — quick mode is recorded and honoured"
OUTQ="$(run "phỏng vấn nhanh thôi: tôi muốn thêm nút xuất Excel cho trang báo cáo" --session-id "$(uuidgen | tr '[:upper:]' '[:lower:]')")"
if sane "$OUTQ" "T2c quick mode honoured"; then
  QQ="$(qmarks "$OUTQ")"
  if printf '%s' "$OUTQ" | grep -qiE 'nhanh|quick'; then
    ok "T2c quick request acknowledged (not silently upgraded)"
  else
    bad "T2c quick request acknowledged" "no sign the quick depth was registered"
  fi
  [ "$QQ" -le 2 ] && ok "T2d quick mode still one question per turn ($QQ marks)" \
                  || bad "T2d quick mode still one question per turn" "found $QQ question marks"
fi

newwork
echo; echo "T5 — rule 7: never answers for the user when a question is ignored"
R7SID="$(uuidgen | tr '[:upper:]' '[:lower:]')"
run "/interview quy trình duyệt hoàn tiền của công ty tôi đang rất chậm" --session-id "$R7SID" >/dev/null
OUTA="$(run "Khách gửi yêu cầu qua Facebook, sale nhận rồi chuyển cho kế toán." --resume "$R7SID")"
OUTB="$(run "Kế toán kiểm rồi trình giám đốc duyệt, thường mất 3-5 ngày." --resume "$R7SID")"
# Strip negated mentions first: "tôi sẽ KHÔNG tự quyết thay bạn" is the rule being obeyed,
# not broken, and a bare substring match reads it as a violation.
SELFDECIDE='tự chốt|tự quyết|tôi chọn giúp|mặc định là|tôi sẽ giả định|I.ll decide|I will decide|I.ll assume|defaulting to'
CLAIMS="$(printf '%s\n%s' "$OUTA" "$OUTB" | grep -oiE ".{0,40}($SELFDECIDE)" \
          | grep -viE "không|chưa|never|not |n't|thay vì|instead")"
if [ -n "$CLAIMS" ]; then
  bad "T5a never decides on the user's behalf" "reply announced its own decision: $(printf '%s' "$CLAIMS" | head -1)"
else
  ok "T5a never decides on the user's behalf"
fi
if sane "$OUTB" "T5b reformulates instead of repeating"; then
  if [ "$OUTA" = "$OUTB" ]; then
    bad "T5b reformulates instead of repeating" "second reply is byte-identical to the first"
  else
    ok "T5b reformulates instead of repeating"
  fi
  QB="$(qmarks "$OUTB")"
  [ "$QB" -ge 1 ] && ok "T5c still asking, not moving on silently ($QB marks)" \
                  || bad "T5c still asking, not moving on silently" "no question in the reply"
fi

newwork
echo; echo "T6 — rule 8: an answer found in sent material is verified, not assumed"
R8SID="$(uuidgen | tr '[:upper:]' '[:lower:]')"
run "/interview quy trình duyệt hoàn tiền của công ty tôi đang rất chậm" --session-id "$R8SID" >/dev/null
run "Tiếng Việt, sâu" --resume "$R8SID" >/dev/null
OUTM="$(run "Gửi bạn trích quy trình nội bộ của bên mình: \"Mọi yêu cầu hoàn tiền trên 50 triệu VND bắt buộc phải có phê duyệt của giám đốc.\"" --resume "$R8SID")"
if sane "$OUTM" "T6 verifies material"; then
  if printf '%s' "$OUTM" | grep -q "50"; then
    ok "T6a quotes the passage back rather than paraphrasing"
  else
    bad "T6a quotes the passage back rather than paraphrasing" "the threshold from the material does not appear in the reply"
  fi
  if printf '%s' "$OUTM" | grep -qiE "còn đúng|đúng không|xác nhận|thực t(ế|e)|có phải|still true|confirm|verify"; then
    ok "T6b asks the user to confirm it"
  else
    bad "T6b asks the user to confirm it" "no verification question — the material may have been treated as settled"
  fi
  QM="$(qmarks "$OUTM")"
  [ "$QM" -ge 1 ] && ok "T6c still exactly one question ($QM marks)" \
                  || bad "T6c still exactly one question" "no question in the reply"
fi

newwork
T3SID="$(uuidgen | tr '[:upper:]' '[:lower:]')"
run "/interview quy trình duyệt hoàn tiền của công ty tôi đang rất chậm" --session-id "$T3SID" >/dev/null
run "Tiếng Việt, sâu" --resume "$T3SID" >/dev/null
SID="$T3SID"
echo; echo "T3 — transcript written after every answer, not batched"
run "Khách gửi yêu cầu qua Facebook, sale nhận rồi chuyển cho kế toán." --resume "$SID" >/dev/null
T="$(find "$WORK/interview" -name transcript.md 2>/dev/null | head -1)"
if [ -n "$T" ]; then
  L1=$(wc -l <"$T"); ok "T3a transcript.md created mid-interview ($L1 lines)"
  # What this asserts is that logging is not batched to the end — not that every single
  # turn appends. Rules 6 and 7 make some turns legitimately add nothing: a doubled reply
  # is voided, and a climb rung parks the answer rather than logging a Q&A block. So give
  # it several answering turns and require growth somewhere in them.
  L2=$L1
  for ans in "Kế toán kiểm rồi trình giám đốc duyệt, thường mất 3-5 ngày." \
             "Có, khách được báo qua Facebook khi tiền đã chuyển." \
             "Mục tiêu là rút xuống dưới 24 giờ."; do
    [ "$L2" -gt "$L1" ] && break
    run "$ans" --resume "$SID" >/dev/null
    L2=$(wc -l <"$T")
  done
  [ "$L2" -gt "$L1" ] && ok "T3b transcript grew during the interview ($L1 → $L2)" \
                      || bad "T3b transcript grew during the interview" "still $L2 lines after three answering turns — logging looks batched"
else
  bad "T3a transcript.md created mid-interview" "no transcript.md under $WORK/interview"
fi

echo; echo "T4 — fresh session resumes instead of restarting"
OUT4="$(run "/interview")"
if sane "$OUT4" "T4 resume"; then
  if printf '%s' "$OUT4" | grep -qiE 't(ầ|a)ng|layer|c(â|a)u [0-9]|q[0-9]|ti(ế|e)p t(ụ|u)c|resum'; then
    ok "T4a reports where it left off"
  else
    bad "T4a reports where it left off" "no layer/question position in reply"
  fi
  if printf '%s' "$OUT4" | grep -qiE 'b(à|a)i to(á|a)n b(ạ|a)n mu(ố|o)n t(ô|o)i hi(ể|e)u l(à|a) g(ì|i)'; then
    bad "T4b does not re-ask the opening question" "asked the opening question again"
  else
    ok "T4b does not re-ask the opening question"
  fi
fi

echo; echo "────────────────────────────"
printf 'passed %d, failed %d\n' "$PASS" "$FAIL"
[ "$FAIL" -eq 0 ] || { dump; exit 1; }
