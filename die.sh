#!/usr/bin/sh

# When writing shell scripts, we sometimes encounter error conditions that are
# outside of the scope of the script to handle. When this happens, we should
# exit the script with a nonzero exit code and a brief message explaining what
# went wrong.

# To make writing scripts easier, I like to add a function to the top of my
# scripts named `die` which simplifies the process of exiting with an error
# message. I call this the "die pattern".

# I'm not the inventor of the "die pattern", its something that I've picked up
# from reading lots of other shell scripts. I think the `die` pattern
# originates from Perl, which has a similar built in function named `die`.

# There are many variations on the die function, but they all do roughly the
# same thing. Here is one possible implementation:

die() {
	printf '%s\n' "$*" >&2
	exit 1
}

# Here we can see the die function being used to guard against cd failing.

cd "/path/that/doesnt/exist" 2>/dev/null || die "Path doesn't exist!"

