#!/bin/sh
# Builds public/index.html from hotstick-sim.html (the single source file).
# hotstick-sim.html is written as a page fragment (no <!doctype>/<html>/<body>),
# so wrap it into a complete standards-mode document for static hosting.
set -e
cd "$(dirname "$0")"
mkdir -p public
python3 - <<'PY'
src = open("hotstick-sim.html", encoding="utf-8").read()
head, sep, body = src.partition("</style>")
if not sep:
    raise SystemExit("hotstick-sim.html: </style> not found")
html = ('<!doctype html>\n<html lang="th">\n<head>\n' + head + sep +
        '\n</head>\n<body>\n' + body.lstrip("\n") + '\n</body>\n</html>\n')
open("public/index.html", "w", encoding="utf-8").write(html)
print("built public/index.html")
PY
