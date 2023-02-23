#!/usr/bin/env bash
# NOT used

# run with the same name
run() {
    if (command -v "$1" && ! pgrep -f "$@"); then
        "$@"&
    fi
}

run picom --experimental-backends
