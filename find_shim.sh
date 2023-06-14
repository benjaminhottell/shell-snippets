#!/bin/sh

# I remember reading somewhere that very old or obscure versions of `find` do not support the `+` end to `-exec`. So, instead of writing the following command:

#     $ find ... -exec my-command +

# You would instead have to write the following command:

#     $ find ... -exec my-command \;

# The second form is less efficient compared to the first form, since hundreds or even thousands of additional subprocesses will forked. (For an explanation of why, see `find`'s man page)

# This script provides a way to detect whether the user's `find` executable supports the `+` ending to `-exec`, and will automatically fall back to `;` if it does not work.

# Users may override the support check by defining the environment variable FINDPLUS. Setting it to 1 will signal that it is supported, setting it to 0 will signal that it is _not_ supported.


# IN PRACTICE, this find shim is likely unnecessary in your script. Versions of `find` which do not support `+` are exceptionally rare.


[ -z "$FIND" ] && FIND='find'

if [ -z "$FINDPLUS" ]; then
	if "$FIND" /dev/null -maxdepth 0 -exec true "{}" + 2>/dev/null; then
		FINDPLUS=1
	else
		FINDPLUS=0
	fi
fi

_find_shim() {
	if [ "$FINDPLUS" -eq 1 ]; then
printf '%s: %s\n' 'FINDPLUS' "$FINDPLUS" >&2
		"$FIND" "$@" +
	else
		"$FIND" "$@" \;
	fi
}


# This will invoke the num_args script which will just print how many arguments were received. If plus support is enabled, then we should see hundreds or thousands of arguments are passed at a time. If plus support is disabled, then we should see one argument at a time.
_find_shim "$HOME" -exec sh num_args.sh '{}'

