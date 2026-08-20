#!/usr/bin/env bash
# Validates a CTAM story packet against the canonical template.
#
#   scripts/validate-story-packet.sh <path-to-packet.md> [...]
#
# Exists because a hand-authored packet once diverged from BMad's story template, leaving
# bmad-dev-story with no Tasks to work through and nowhere to write its Dev Agent Record. Prose
# alone did not prevent that; this does. Runnable from anywhere.
#
# Canonical template: ctam-architecture/agent-rules/templates/story-packet.md
# Contract: BMad's top-level sections, at BMad's heading level, with BMad's spelling. CTAM content
# only in the frontmatter and as subsections of "## Dev Notes". Exactly one status.

set -uo pipefail

[ "$#" -ge 1 ] || { echo "usage: $(basename "$0") <packet.md> [...]" >&2; exit 2; }

# Sections bmad-dev-story reads or writes. Renaming or dropping one breaks the dev workflow.
REQUIRED_SECTIONS=(
  '^## Story$'
  '^## Acceptance Criteria$'
  '^## Tasks / Subtasks$'
  '^## Dev Notes$'
  '^## Dev Agent Record$'
  '^### File List$'
)
# CTAM frontmatter — the polyrepo facts BMad does not model. sprint_status_key links the packet
# to its entry in sprint-status.yaml, which is the programme-level rollup.
REQUIRED_KEYS=(story_id epic repo bus_version frs nfrs depends_on_stories sprint_status_key)
# CTAM content promoted to a top-level heading instead of nesting under Dev Notes.
FORBIDDEN_SECTIONS=(
  '^## Context'
  '^## Out of scope'
  '^## Definition of done'
  '^## Recorded deviations'
  '^## Read before you start'
  '^## Open questions'
  '^## Expected shape'
  '^## Rules that apply'
)
STATUS_VOCAB='ready-for-dev|in-progress|review|done'

rc=0

for packet in "$@"; do
  echo "== $packet"
  if [ ! -f "$packet" ]; then
    echo "   ERROR: no such file"; rc=1; continue
  fi
  errors=0

  for section in "${REQUIRED_SECTIONS[@]}"; do
    grep -qE "$section" "$packet" || {
      echo "   ERROR: missing required section: ${section//[\^$]/}"
      echo "          bmad-dev-story reads or writes this section by exact heading."
      errors=$((errors + 1))
    }
  done

  for section in "${FORBIDDEN_SECTIONS[@]}"; do
    if grep -qE "$section" "$packet"; then
      echo "   ERROR: CTAM content at top level: ${section//[\^$]/}"
      echo "          Nest it as a '###' subsection of '## Dev Notes' instead."
      errors=$((errors + 1))
    fi
  done

  status_line=$(grep -m1 -E '^Status:' "$packet" || true)
  if [ -z "$status_line" ]; then
    echo "   ERROR: no 'Status:' line — bmad-dev-story flips this as work progresses"
    errors=$((errors + 1))
  elif ! printf '%s' "$status_line" | grep -qE "^Status:[[:space:]]*(${STATUS_VOCAB})[[:space:]]*$"; then
    echo "   ERROR: $status_line"
    echo "          allowed: ${STATUS_VOCAB//|/, }  (BMad vocabulary — the only status vocabulary there is)"
    errors=$((errors + 1))
  fi

  # Frontmatter is lines 2..N up to the closing '---'.
  frontmatter=$(awk 'NR==1 && $0=="---"{inside=1; next} inside && $0=="---"{exit} inside{print}' "$packet")
  if [ -z "$frontmatter" ]; then
    echo "   ERROR: no YAML frontmatter — the polyrepo fields live there"
    errors=$((errors + 1))
  else
    for key in "${REQUIRED_KEYS[@]}"; do
      printf '%s\n' "$frontmatter" | grep -qE "^${key}:" || {
        echo "   ERROR: frontmatter missing required key: ${key}"
        errors=$((errors + 1))
      }
    done
    if printf '%s\n' "$frontmatter" | grep -qE '^status:'; then
      echo "   ERROR: frontmatter carries a 'status:' key as well as the 'Status:' line."
      echo "          One status only, in BMad's vocabulary. Two statuses in two vocabularies is"
      echo "          the exact defect this validator exists to prevent."
      errors=$((errors + 1))
    fi
  fi

  grep -qE '^[0-9]+\. ' "$packet" || {
    echo "   ERROR: no numbered acceptance criteria — AC ids must resolve to a list item (T6)"
    errors=$((errors + 1))
  }

  grep -qE '^- \[[ x]\] ' "$packet" || {
    echo "   ERROR: no task checkboxes under Tasks / Subtasks for bmad-dev-story to work through"
    errors=$((errors + 1))
  }
  grep -qE '^- \[[ x]\] .*\(AC: *[0-9]' "$packet" || {
    echo "   WARN:  no task cites an AC number — every task should name the AC it serves"
  }

  if [ "$errors" -eq 0 ]; then
    echo "   OK — conforms to the canonical story-packet contract"
  else
    echo "   $errors error(s)"
    rc=1
  fi
done

exit "$rc"
