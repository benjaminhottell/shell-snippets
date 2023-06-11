#!/usr/bin/sh

# (Suggested prerequisite: temp_file.sh)

# This script illustrates how to safely clean up resources (such as temporary
# files) in a POSIX shell script.

# The strategy is to register two functions which will run when the script
# exits and when the script is interrupted.

# The interrupt handler will pass control to the exit handler. The exit handler
# will then clean up a temporary file for demonstration purposes. (You can
# imagine the temporary file being whatever other resource your script
# allocates)

# This way, the cleanup code runs whether the script exits normally, gets
# interrupted, or encounters an error.

# (Of course, this doesn't protect against extremely abnormal exits such as the
# machine losing power - so don't count on it like you would an ACID database)


# I make sure to clear this variable just in case the user or another script
# accidentally set it. (This script will use it later)
TEMP_FILE=""


# Print a message to stderr
warn() {
	printf '%s\n' "$*" >&2
}

# This is our exit handler. We will use it to delete the temporary file.
_on_exit() {
	warn "(in cleanup function)"
	[ -n "$TEMP_FILE" ] && rm "$TEMP_FILE"
}

# If the script is interrupted, we want it to exit through our exit handler as
# opposed to immediately exiting
_on_interrupt() {
	exit 1
}


TEMP_FILE="$(mktemp)" || exit 1

warn "Temp file: $TEMP_FILE"

trap _on_exit EXIT
trap _on_interrupt INT HUP TERM

warn "Press ctrl+c to interrupt me, or wait a while for a normal exit"
sleep 5

warn "(Exiting normally...)"

