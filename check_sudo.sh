#!/bin/sh

# This command will noninteractively and silently check if the script has
# 'sudo' powers.

sudo -n true 2>/dev/null

# We can use it as an 'if' condition:

if ! sudo -n true 2>/dev/null; then
	printf '%s\n' "Please run this script with sudo!"
	exit 1
fi

printf '%s\n' 'Hello, root!'
