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
OUT2="$(run "Tiếng Việt" --resume "$SID")"
if sane "$OUT2" "T2b exactly one question on turn 2"; then
  Q2="$(qmarks "$OUT2")"
  [ "$Q2" = 1 ] && ok "T2b exactly one question on turn 2 (monolingual)" \
                || bad "T2b exactly one question on turn 2" "found $Q2 question marks, expected exactly 1"
fi

echo; echo "T3 — transcript written after every answer, not batched"
run "Khách gửi yêu cầu qua Facebook, sale nhận rồi chuyển cho kế toán." --resume "$SID" >/dev/null
T="$(find "$WORK/interview" -name transcript.md 2>/dev/null | head -1)"
if [ -n "$T" ]; then
  L1=$(wc -l <"$T"); ok "T3a transcript.md created mid-interview ($L1 lines)"
  run "Kế toán kiểm rồi trình giám đốc duyệt, thường mất 3-5 ngày." --resume "$SID" >/dev/null
  L2=$(wc -l <"$T")
  [ "$L2" -gt "$L1" ] && ok "T3b transcript grew after next answer ($L1 → $L2)" \
                      || bad "T3b transcript grew after next answer" "still $L2 lines — logging looks batched"
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
