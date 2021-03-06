cp src/appendix-pre.adoc src/appendix-post.adoc;
adoc-math src/appendix-post.adoc \
    --default-lang tex \
    --default-scale 65;
OUT_FILE="abch-${PWD##*/}.pdf";
python3 -m make_report && \
asciidoctor-pdf \
    --verbose \
    --trace \
    --failure-level=ERROR \
    --out-file="$OUT_FILE" \
    "$@" main.adoc