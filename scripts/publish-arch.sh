#!/usr/bin/env bash
# Publishes the canonical architecture set from this control-plane repo to the context bus
# (ctam-architecture), which service repos consume as a version-pinned git submodule.
#
#   scripts/publish-arch.sh [path-to-ctam-architecture]     # default: ../ctam-architecture
#
# Canonical source stays here (_bmad-output/planning-artifacts/). The bus copy is a MIRROR:
# never hand-edit it — change the canonical file and re-run this script. Runnable from anywhere.
#
# This script performs NO version-control operations. After running it, the human reviews the
# diff in the bus repo, commits it, and publishes the arch-vN tag externally (see
# the delivery operating model for the bus-pinning rule).
#
# See _bmad-output/planning-artifacts/architecture/delivery-operating-model.md.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
SRC="$REPO_ROOT/_bmad-output/planning-artifacts"
BUS="${1:-$(cd "$REPO_ROOT/.." && pwd)/ctam-architecture}"

[ -d "$SRC" ] || { echo "error: no planning-artifacts at $SRC" >&2; exit 1; }
[ -d "$BUS/.git" ] || { echo "error: $BUS is not a version-controlled directory — expected the context bus" >&2; exit 1; }

echo "publishing"
echo "  from: $SRC"
echo "  to:   $BUS"

mkdir -p "$BUS/architecture"

# The index + its shards. Prose only: diagrams/, sequence-diagrams/ and analysis/ are not
# published yet (they are large and nothing in agent-rules cites them) — add them here when a
# consumer needs them, rather than copying selectively by hand.
copy() {
  local rel="$1"
  if [ -f "$SRC/$rel" ]; then
    cp "$SRC/$rel" "$BUS/$rel"
    echo "  + $rel"
  else
    echo "  ! missing in source, skipped: $rel" >&2
  fi
}

copy architecture.md
copy architecture-summary.md
copy prd.md                       # mirror; canonical lives here (per repo-structure.md)

for f in "$SRC"/architecture/*.md; do
  [ -f "$f" ] || continue
  copy "architecture/$(basename "$f")"
done

# The mirror warning travels with the payload so nobody edits the copy.
cat > "$BUS/architecture/PUBLISHED.md" <<'NOTE'
# Published mirror — do not hand-edit

Every `.md` beside this file, plus `../architecture.md`, `../architecture-summary.md` and
`../prd.md`, is a **published mirror**. The canonical source is the control plane:

    ctam-analysis/_bmad-output/planning-artifacts/

To change any of it: change the canonical file there, then re-run
`ctam-analysis/scripts/publish-arch.sh` and publish a new `arch-vN` tag. Editing a file here
creates exactly the drift the delivery operating model exists to prevent, and the next publish
would silently overwrite it.

`agent-rules/` is **not** a mirror — it is authored here, on the bus. See `agent-rules/index.md`.
NOTE
echo "  + architecture/PUBLISHED.md"

echo
echo "done. Review the diff in $BUS, then commit and tag it externally."
