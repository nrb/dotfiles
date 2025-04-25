#!/usr/bin/env bash

if [[ $# -ne 1 ]]; then
    echo "Expecting exactly 1 argument; 'personal' or 'work'" >&2
    exit 1
fi

case $1 in
    personal|work)
        brew bundle dump --file Brewfile.$1
        ;;
    *)
        echo "Expected 'personal' or 'work'" >&2
        exit 1
esac
