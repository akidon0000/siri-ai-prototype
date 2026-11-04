#!/bin/sh
# Writes redirect pages for tutorial URLs that were renamed, into a built DocC site.
# Usage: tools/docc-redirects.sh <site-dir> <hosting-base-path>
set -eu

site="$1"
base="/$2/tutorials/appfeature"

redirect() {
  dir="$site/tutorials/appfeature/$1"
  mkdir -p "$dir"
  cat > "$dir/index.html" <<EOF
<!doctype html>
<html lang="ja">
<head>
<meta charset="utf-8">
<title>移動しました</title>
<link rel="canonical" href="$base/$2/">
<meta http-equiv="refresh" content="0; url=$base/$2/">
<script>location.replace("$base/$2/" + location.hash);</script>
</head>
<body><p>このチュートリアルは <a href="$base/$2/">$base/$2/</a> に移動しました。</p></body>
</html>
EOF
}

redirect 01-sirikit-limits 01-sirikit-to-app-intents
redirect 04-apple-intelligence-siri-ai 06-apple-intelligence-context
redirect 05-siri-ai-tool-intent 07-siri-ai-tools
