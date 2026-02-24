#!/usr/bin/env bash
# validate-all.sh — Lint all AgentSkills plugins in the monorepo
# Checks: required files exist, package.json is valid JSON, skill.yaml or src/ present

set -euo pipefail
REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
SKILLS_DIR="$REPO_ROOT/skills"
ERRORS=0
COUNT=0

validate_json() {
  node -e "
    try { JSON.parse(require('fs').readFileSync(process.argv[1],'utf8')); process.exit(0); }
    catch { process.exit(1); }
  " "$1" 2>/dev/null
}

for skill_dir in "$SKILLS_DIR"/*/; do
  name=$(basename "$skill_dir")
  COUNT=$((COUNT + 1))

  # Must have package.json
  if [ ! -f "$skill_dir/package.json" ]; then
    echo "ERROR: $name — missing package.json"
    ERRORS=$((ERRORS + 1))
    continue
  fi

  # package.json must be valid JSON
  if ! validate_json "$skill_dir/package.json"; then
    echo "ERROR: $name — invalid package.json"
    ERRORS=$((ERRORS + 1))
  fi

  # Must have either skill.yaml (pure AgentSkills) or src/ (TypeScript skills)
  if [ ! -f "$skill_dir/skill.yaml" ] && [ ! -d "$skill_dir/src" ]; then
    echo "WARN:  $name — no skill.yaml or src/ directory"
  fi

  # Check openclaw.plugin.json if present
  if [ -f "$skill_dir/openclaw.plugin.json" ]; then
    if ! validate_json "$skill_dir/openclaw.plugin.json"; then
      echo "ERROR: $name — invalid openclaw.plugin.json"
      ERRORS=$((ERRORS + 1))
    fi
  fi

  echo "  OK:  $name"
done

echo ""
echo "Validated $COUNT skills, $ERRORS errors"

if [ "$ERRORS" -gt 0 ]; then
  exit 1
fi
