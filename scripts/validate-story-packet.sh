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
# The ONLY top-level sections the contract permits. Anything else at '## ' level is either CTAM
# content promoted out of Dev Notes, or one of bmad-create-story step 5's eleven named outputs
# (architecture_compliance, testing_requirements, latest_tech_information, git_intelligence_summary,
# ...) written literally instead of routed into an existing home. This was a blacklist of eight
# known headings, which only ever caught a name someone had predicted; step 5's outputs are named
# nothing like them and sailed through. An allowlist rejects the whole class by construction.
ALLOWED_SECTIONS=(
  'Story'
  'Acceptance Criteria'
  'Tasks / Subtasks'
  'Dev Notes'
  'Dev Agent Record'
)
ALLOWED_DISPLAY=$(printf "'%s', " "${ALLOWED_SECTIONS[@]}"); ALLOWED_DISPLAY="${ALLOWED_DISPLAY%, }"
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

  while IFS= read -r heading; do
    name="${heading#\#\# }"
    name="${name%"${name##*[![:space:]]}"}"        # rstrip
    permitted=0
    for allowed in "${ALLOWED_SECTIONS[@]}"; do
      [ "$name" = "$allowed" ] && { permitted=1; break; }
    done
    if [ "$permitted" -eq 0 ]; then
      echo "   ERROR: top-level section not in the contract: '## $name'"
      echo "          permitted at '##': ${ALLOWED_DISPLAY}"
      echo "          Everything else nests as a '###' subsection of '## Dev Notes'."
      errors=$((errors + 1))
    fi
  done < <(grep -E '^## ' "$packet")

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

    # story_id must be CTAM's three-part <phase>.<epic>.<story>, and must agree with the filename,
    # sprint_status_key and H1. Presence alone was not enough: BMad's default key parse yields a
    # TWO-part id (epic 0.1 story 4 -> "0.1"), which is present, plausible, and puts every story in
    # an epic at one path and on one branch. Present-but-wrong needs a shape check.
    fm_value() {
      printf '%s\n' "$frontmatter" |
        awk -v k="^$1:" '$0 ~ k { sub(/^[^:]*:[[:space:]]*/, ""); sub(/[[:space:]]*#.*$/, ""); gsub(/[[:space:]]*$/, ""); print; exit }'
    }
    sid=$(fm_value story_id)
    if [ -n "$sid" ]; then
      if ! printf '%s' "$sid" | grep -qE '^[0-9]+\.[0-9]+\.[0-9]+$'; then
        echo "   ERROR: story_id '$sid' is not <phase>.<epic>.<story> (e.g. 0.1.4)"
        echo "          A two-part id means BMad's default key parse was taken unchanged."
        errors=$((errors + 1))
      fi
      base=$(basename "$packet" .md)
      if [ "$base" != "$sid" ]; then
        echo "   ERROR: filename '$base.md' does not match story_id '$sid'"
        echo "          a packet lives at docs/stories/<story_id>.md"
        errors=$((errors + 1))
      fi
      ssk=$(fm_value sprint_status_key)
      dashed="${sid//./-}"
      if [ -n "$ssk" ] && [ "${ssk#"$dashed"-}" = "$ssk" ]; then
        echo "   ERROR: sprint_status_key '$ssk' does not start with '$dashed-'"
        echo "          it is this story's key in sprint-status.yaml, so it carries the same id"
        errors=$((errors + 1))
      fi
      if ! grep -qE "^# Story ${sid//./\\.}: .+" "$packet"; then
        echo "   ERROR: no '# Story $sid: <title>' heading"
        echo "          the H1 carries the full three-part id, not the owning epic's"
        errors=$((errors + 1))
      fi
    fi

    # depends_on_stories carries three-part ids too. It is derived, not recorded anywhere upstream,
    # so a two-part id here means an epic reference was written where a story reference belongs.
    deps=$(fm_value depends_on_stories)
    deps="${deps//[\[\]]/}"
    for d in $(printf '%s' "$deps" | tr ',' ' '); do
      d="${d//[[:space:]]/}"
      [ -z "$d" ] && continue
      printf '%s' "$d" | grep -qE '^[0-9]+\.[0-9]+\.[0-9]+$' || {
        echo "   ERROR: depends_on_stories entry '$d' is not a three-part story id (e.g. 0.1.1)"
        errors=$((errors + 1))
      }
    done
  fi

  # Unfilled template placeholders. Story 0.0.0 (the GitHub setup runbook) made this reachable:
  # the template ships `story_id: 0.0.0` and `sprint_status_key: 0-0-0-<kebab-title>` as its
  # EXAMPLES, and for that one story those satisfy the id, filename, H1 and prefix checks above --
  # so a packet where nobody filled the frontmatter in would have passed. Catch the placeholders
  # themselves instead of special-casing one id. {{agent_model_name_version}} is exempt: dev-story
  # fills it, not the dispatcher.
  # Angle-bracket placeholders are FRONTMATTER VALUES only. Scanning the whole file for them was
  # wrong: `ctam-<service>` is the documented CNP naming convention and appears legitimately in
  # acceptance criteria copied verbatim from an epic, which W8 forbids editing. A guard that forces
  # a packet to paraphrase its own ACs is worse than the gap it closes.
  for ph in '<service>' '<slug>' '<kebab-title>'; do
    if printf '%s\n' "$frontmatter" | grep -qF -- "$ph"; then
      echo "   ERROR: unfilled frontmatter placeholder: $ph"
      echo "          the packet still carries story-packet.md's example values"
      errors=$((errors + 1))
    fi
  done
  # Body placeholders are unambiguous wherever they appear. {{agent_model_name_version}} is exempt:
  # bmad-dev-story fills it, not the dispatcher.
  for ph in '{{role}}' '{{action}}' '{{benefit}}' '{{epic_num}}' '{{story_num}}' \
            '{{story_title}}' '[from the epic'; do
    if grep -qF -- "$ph" "$packet"; then
      echo "   ERROR: unfilled template placeholder: $ph"
      echo "          the packet still carries story-packet.md's example text"
      errors=$((errors + 1))
    fi
  done

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
