#!/bin/sh

# Use $# to find the number of arguments that were passed to your script.

# Using `shift` will decrement the number of arguments by 1.

printf 'Num. args: %s\n' "$#"
