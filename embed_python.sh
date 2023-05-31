#!/usr/bin/sh

# Major weaknesses of embedded Python scripts:
#   - Shell script linters don't go into Python scripts, they won't find bugs
#   - What do you do if Python isn't installed?
#   - What do you do if the wrong version of Python is installed?
#   - Decreased readability; maintainers must know both languages

# Overall it is better to either find a shell-script-only alternative, or to
# rewrite and distribute the embedded Python script as a separate dependency.
# (This way, you'll have better support from linters and package dependency
# management)

# With all of this in mind, I only recommend embedding Python scripts within a
# shell script if the embedded Python is small (e.g. 1-3 lines) and has no
# dependencies (outside of Python itself) and that functionality cannot be
# easily implemented otherwise.



# STRATEGY 1: Embed the Python script as an argument, invoke with python -c

# Strengths:
#   - stdin is free to be used with the script (contrast with strategy 2)
#   -

# Weaknesses:
#   - Cannot use stdin (its used up by the heredoc)
#   - The first and last lines are muddied with shell formatting (quotes)

THE_SCRIPT="user_in = input()
print(user_in.upper())"

echo 'Input string' | python -c "$THE_SCRIPT"



# STRATEGY 2: Embed the Python script as a heredoc, invoke with python -

# Strengths:
#   - First and last lines of the script are free of shell formatting

# Weaknesses:
#   - Cannot use stdin (its used up by the heredoc)
#   - Inputting data can get tricky!

python - "Input string" << EOF
import sys
user_in = sys.argv[1]
print(user_in.upper())
EOF



# STRATEGY 3: Write the python script to a temporary file, invoke the temporary
# file as though it were any other Python script

# Strengths:
#   - You can invoke the embedded script as though it were any other script on
#     the filesystem

# Weaknesses:
#   - Significantly more moving parts, think about Murphy's law
#   - Why don't you just distribute a standalone script at this point?
#   - This strategy is only shown for completion; please don't do this

TEMP_FILE=""

rm_temps() {
	[ -n "$TEMP_FILE" ] && rm "$TEMP_FILE"
}

die() {
	rm_temps
	printf '%s\n' "$*" >&2
	exit 1
}

TEMP_FILE="$(mktemp)" || die 'mktemp failure'

cat > "$TEMP_FILE" << EOF
user_in = input()
print(user_in.upper())
EOF

echo "Temp file: $TEMP_FILE"
echo "Input string" | python "$TEMP_FILE"

rm_temps

