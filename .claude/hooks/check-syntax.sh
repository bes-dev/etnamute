#!/bin/bash
# Fast syntax check for TypeScript/TSX files after edit.
# Returns errors to Claude's context so it can fix immediately.

INPUT=$(cat)
FILE_PATH=$(echo "$INPUT" | jq -r '.tool_input.file_path // empty')

# Only check TypeScript files in apps/
[[ "$FILE_PATH" != apps/*.ts && "$FILE_PATH" != apps/*.tsx ]] && exit 0
[[ ! -f "$FILE_PATH" ]] && exit 0

# Find nearest tsconfig
DIR=$(dirname "$FILE_PATH")
TSCONFIG=""
while [[ "$DIR" != "." && "$DIR" != "/" ]]; do
  [[ -f "$DIR/tsconfig.json" ]] && TSCONFIG="$DIR/tsconfig.json" && break
  DIR=$(dirname "$DIR")
done

[[ -z "$TSCONFIG" ]] && exit 0

# Quick syntax check — only the changed file, no full project rebuild
ERRORS=$(npx tsc --noEmit --pretty false "$FILE_PATH" 2>&1 | head -5)

if [[ -n "$ERRORS" && "$ERRORS" != *"error TS18003"* ]]; then
  echo "TypeScript errors in $FILE_PATH:"
  echo "$ERRORS"
  echo ""
  echo "Fix these before continuing."
fi

exit 0
