#! /usr/bin/env sh

timeout="10m"
subfolder="assets"

DIR="$ZK_NOTEBOOK_DIR/$subfolder"

[[ ! -d "$DIR" ]] && mkdir "$DIR" && sleep 1
open "$ZK_NOTEBOOK_DIR"

sleep 1

osascript "$ZK_NOTEBOOK_DIR/.zk/scripts/sketch.scpt" "$subfolder"

file=`timeout --foreground "$timeout" fswatch --event=Created -1 -e '[^(png)]$' "$DIR"`

if [ "$?" -gt 0 ]; then exit $?; fi
if [ -z "$file" ]; then exit 1 ; fi

newfile="`hexdump -n 4 -e '2/2 \"%02x\" 1 \"\n\"' /dev/urandom`.png"

while [ -f "$DIR/$newfile" ]; do
  newfile="`hexdump -n 4 -e '2/2 \"%02x\" 1 \"\n\"' /dev/urandom`.png" 
done

mv "$file" "$DIR/$newfile"

convert "$DIR/$newfile" -colorspace HSL -channel L -negate "$DIR/$newfile"

echo "$DIR/$newfile"
