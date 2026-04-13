#!/bin/bash
set -euo pipefail

REPO_DIR="$(cd "$(dirname "$0")/.." && pwd)"
REMOTE="bot:/opt/blog-hyperskills/"

echo "=== Blog deploy ==="
echo "Repo: $REPO_DIR"
echo ""

# 1. Local checks
echo "--- Running checks ---"
ERRORS=0

for f in "$REPO_DIR"/*.html; do
  name=$(basename "$f")
  echo "Checking $name..."

  # DOCTYPE
  if ! head -1 "$f" | grep -qi 'doctype'; then
    echo "  FAIL: missing <!DOCTYPE html>"
    ERRORS=$((ERRORS + 1))
  fi

  # meta description
  if ! grep -qi 'name="description"' "$f"; then
    echo "  FAIL: missing <meta name=\"description\">"
    ERRORS=$((ERRORS + 1))
  fi

  # canonical
  if ! grep -qi 'rel="canonical"' "$f"; then
    echo "  FAIL: missing <link rel=\"canonical\">"
    ERRORS=$((ERRORS + 1))
  fi

  # Open Graph
  if ! grep -qi 'property="og:title"' "$f"; then
    echo "  FAIL: missing og:title"
    ERRORS=$((ERRORS + 1))
  fi

  # viewport
  if ! grep -qi 'name="viewport"' "$f"; then
    echo "  FAIL: missing viewport"
    ERRORS=$((ERRORS + 1))
  fi

  # EN/FR toggle
  if ! grep -qi 'i18n\|lang-content\|data-lang\|setLang\|switchLang' "$f"; then
    echo "  WARN: no EN/FR toggle detected in $name"
  fi

  # Copyright
  if ! grep -qi 'CC BY-SA' "$f"; then
    echo "  WARN: no CC BY-SA in $name"
  fi

  # GoatCounter tracking — auto-inject if missing
  if ! grep -q 'goat.cybernego.com/count' "$f"; then
    if grep -q '</body>' "$f"; then
      sed -i '' 's|</body>|<script>window.goatcounter = { path: function(p) { return location.host + p } }</script>\n<script data-goatcounter="https://goat.cybernego.com/count"\n        async src="//goat.cybernego.com/count.js"></script>\n</body>|' "$f"
      echo "  INJECTED: GoatCounter snippet added"
    else
      echo "  FAIL: no </body> found — cannot inject GoatCounter"
      ERRORS=$((ERRORS + 1))
    fi
  fi
done

if [ "$ERRORS" -gt 0 ]; then
  echo ""
  echo "ERRORS: $ERRORS — aborting deploy."
  exit 1
fi

echo ""
echo "All checks passed."
echo ""

# 2. Generate hyperskill links
echo "--- Generating hyperskill links ---"
cd "$REPO_DIR"
npm install --silent 2>/dev/null
node scripts/generate-hyperskill-links.js
echo ""

# 3. Deploy to VM
echo "--- Deploying to VM ---"
scp "$REPO_DIR"/*.html "$REPO_DIR"/fonts.css "$REMOTE"
scp -r "$REPO_DIR"/fonts "$REMOTE"
echo "VM deploy done."
echo ""

# 4. Git commit + push (triggers GitHub Actions → GitHub Pages)
echo "--- Git push ---"
cd "$REPO_DIR"
git add -A
if git diff --cached --quiet; then
  echo "No changes to commit."
else
  git commit -m "deploy: $(date +%Y-%m-%d)"
  git push origin main
  echo "Pushed to GitHub — Actions will deploy to GitHub Pages."
fi

echo ""
echo "=== Done ==="
