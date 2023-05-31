#!/usr/bin/sh

# The `echo` command is very inconsistent between shell implementations. When
# writing portable shell scripts, it is better to use `printf`, since its
# definition is much more consistent.

# Though, `printf` isn't as convenient as `echo`. It would be nice if we could
# combine the simplicity of `echo` with the consistency of `printf`.

# We can do this by defining our own function named `echo`, which will take
# precedence over the shell's `echo`. (We can also name our function something
# else, such as `println`)

# If you run this script, you should see that all lines passed to `echo` are
# printed verbatim, regardless of the presence (or absence) of special flags.

# Shellcheck may still complain that 'echo flags are undefined'. You can
# disable this warning with the following shellcheck directive:
#
# shellcheck disable=SC3037

echo() {
	printf '%s\n' "$*"
}

echo 'hello, world'
echo -n 'hello, world'
echo -ne 'hello, world'
echo -- -n -e 'hello, world'

