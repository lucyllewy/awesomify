#!/bin/bash

urldecode() { : "${*//+/ }"; echo -e "${_//%/\\x}"; }

NAME="$Http_Query"
if [ -z "$NAME" ]; then
    while read NAME; do
        if [ -n "$NAME" ]; then
            break
        fi
    done
fi

NAME="$(echo "$NAME" | sed -E -e 's/^.*[&;]?q=([^&;]+)([;&].*)?$/\1/')"

[ -n "$NAME" ] && NAME="$(urldecode "$NAME")"

if [ -z "$NAME" ]; then
    echo "You need to specify an awesome name"
    exit 1
fi

TMPWAV="$(mktemp -u).wav"

mimic -t "$NAME" -o /dev/stdout | sox -t wav - -c 2 -r 44.1k "$TMPWAV"

CLIPS=()
for clip in "$(dirname $0)"/clip*.wav; do
    CLIPS+=("$clip" "$TMPWAV")
done
unset 'CLIPS[${#CLIPS[@]}-1]'

sox "${CLIPS[@]}" -t wav - \
    | opusenc --bitrate 24 --downmix-mono - - 2> /dev/null

rm -f "$TMPWAV"
