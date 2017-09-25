#!/bin/bash
if type colordiff 1> /dev/null 2>&1 ; then
    colordiff -y "$1" "$2" --width=164
else
    echo "colordiff not installed, using `diff` instead"
    diff -y "$1" "$2" --width=92
fi

