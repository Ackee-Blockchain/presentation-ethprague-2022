# This script requires the Alfred workflow dteiml.build-asciidoc.
# Alfred is a productivity tool for MacOS.
# If you don't have this workflow you can just use ./build-open.sh
./build.sh "$@";
/usr/bin/osascript -e "tell application \"Alfred 4\" to run trigger \"refresh\" in workflow \"com.alfredapp.dteiml.build-asciidoc\"";