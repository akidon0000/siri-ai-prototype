#!/bin/sh
# Adds the Japanese/English switch to a built DocC site: the Japanese site at <site-dir>,
# the English site at <site-dir>/en. Run it before tools/docc-redirects.sh so the redirect pages stay plain.
# Usage: tools/docc-language-switch.sh <site-dir> <hosting-base-path>
set -eu

site="$1"
base="/$2/"
here=$(dirname "$0")

cp "$here/docc-language-switch.js" "$site/language-switch.js"

inject() {
  lang="$1"
  shift
  tag="<script src=\"${base}language-switch.js\" data-lang=\"$lang\" data-base=\"$base\" defer></script>"
  for page in "$@"; do
    grep -q 'language-switch.js' "$page" && continue
    sed -i.bak -e "s#<html lang=\"[^\"]*\"#<html lang=\"$lang\"#" -e "s#</head>#$tag</head>#" "$page"
    rm "$page.bak"
  done
}

# DocC writes one index.html per page; the English build sits under en/.
find "$site" -path "$site/en" -prune -o -name index.html -print | while read -r page; do inject ja "$page"; done
find "$site/en" -name index.html -print | while read -r page; do inject en "$page"; done
