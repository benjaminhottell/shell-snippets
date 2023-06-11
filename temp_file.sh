#!/usr/bin/sh

# Creating a temporary file

# This script does not delete the temporary file if it exists abnormally. This
# has the risk of leaving behind a stray temp file on some systems.

# Read next: cleanup_on_exit.sh

TEMP_FILE="$(mktemp)" || exit 1

printf 'Temp file: %s\n' "$TEMP_FILE"

printf 'Hello temp file\n' > "$TEMP_FILE"

cat -- "$TEMP_FILE"

rm "$TEMP_FILE"
