OUT_FILE="abch-${PWD##*/}.pdf";
python3 -m make_report && \
asciidoctor-pdf \
    --verbose \
    --trace \
    --failure-level=ERROR \
    --out-file="$OUT_FILE" \
    "$@" main.adoc