OUT_FILE="abch-${PWD##*/}.pdf";
python3 -m make_report && \
asciidoctor-pdf \
    --require="./lib/emoji-inline-macro.rb" \
    -a allow-uri-read \
    --verbose \
    --trace \
    --failure-level=ERROR \
    --out-file="$OUT_FILE" \
    "$@" main.adoc