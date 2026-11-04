#!/bin/sh
# Writes redirect pages into a built DocC site: renamed tutorial URLs, and /tutorials/ (the short entry URL).
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

# /tutorials/ を入口のURLにする。DocCは /tutorials/<名前>/ にしかページを作れないので、ここから目次ページへ転送する
entry="/$2/tutorials/siriaitutorials/"
mkdir -p "$site/tutorials"
cat > "$site/tutorials/index.html" <<EOF
<!doctype html>
<html lang="ja">
<head>
<meta charset="utf-8">
<title>Siri AI Tutorials</title>
<link rel="canonical" href="$entry">
<meta http-equiv="refresh" content="0; url=$entry">
<script>location.replace("$entry" + location.hash);</script>
</head>
<body><p><a href="$entry">Siri AI Tutorials</a> へ移動します。</p></body>
</html>
EOF
