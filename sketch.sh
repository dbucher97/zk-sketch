#! /usr/bin/env sh

timeout="10m"
subfolder="assets"

while [[ $# -gt 0 ]]; do
  case $1 in
    -t|--timeout)
      timeout="$2"
      shift # past argument
      shift # past value
      ;;
    -f|--folder)
      subfolder="$2"
      shift # past argument
      shift # past value
      ;;
    -i)
      invert=1
      shift # past argument
      ;;
    -n)
      invert=
      shift # past argument
      ;;
    *|-*|--*)
      echo "Unknown option $1"
      exit 1
      ;;
  esac
done

DIR="$ZK_NOTEBOOK_DIR/$subfolder"

# Make assets dir if does not exist
[[ ! -d "$DIR" ]] && mkdir "$DIR" && sleep 1

# open notebook dir in Finder
open "$ZK_NOTEBOOK_DIR"

# give UI some time
sleep 0.6

# Select assets folder and execute `Import from iPad`.
osascript "$ZK_NOTEBOOK_DIR/.zk/scripts/sketch.scpt" "$subfolder"

# Watch the assets folder until the sketch appears. Timeout after 10 mins.
file=`timeout --foreground "$timeout" fswatch --event=Created -1 -e '[^(png)]$' "$DIR"`

rc="$?"
# Check if timeout or file exists
if [ "$rc" -gt 0 ]; then exit "$rc"; fi
if [ ! -f "$file" ]; then exit 22 ; fi

# Create new unique identifier
newfile="`hexdump -n 4 -e '2/2 \"%02x\" 1 \"\n\"' /dev/urandom`.png"
while [ -f "$DIR/$newfile" ]; do
  newfile="`hexdump -n 4 -e '2/2 \"%02x\" 1 \"\n\"' /dev/urandom`.png" 
done

# Rename file
mv "$file" "$DIR/$newfile"

# Invert the lightness channel if invert option is set.
if [ -n "$invert" ]; then
  convert "$DIR/$newfile" -colorspace HSL -channel L -negate "$DIR/$newfile"
fi

# Return the new file file name
echo "$subfolder/$newfile"
