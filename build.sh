#!/bin/sh
# Builds public/index.html from hotstick-sim.html (the single source file).
# hotstick-sim.html is written as a page fragment (no <!doctype>/<html>/<body>),
# so wrap it into a complete standards-mode document for static hosting.
# Uses Node because it is always present in Vercel's build image.
set -e
cd "$(dirname "$0")"
mkdir -p public
node -e '
const fs = require("fs");
const src = fs.readFileSync("hotstick-sim.html", "utf8");
const i = src.indexOf("</style>");
if (i < 0) { console.error("hotstick-sim.html: </style> not found"); process.exit(1); }
const head = src.slice(0, i + 8), body = src.slice(i + 8).replace(/^\n+/, "");
fs.writeFileSync("public/index.html",
  "<!doctype html>\n<html lang=\"th\">\n<head>\n" + head + "\n</head>\n<body>\n" + body + "\n</body>\n</html>\n");
console.log("built public/index.html");
'
