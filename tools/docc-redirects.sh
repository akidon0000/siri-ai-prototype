#!/bin/sh
# Writes redirect pages into a built DocC site: renamed tutorial URLs, and /tutorials/ (the short entry URL).
# Usage: tools/docc-redirects.sh <site-dir> <hosting-base-path> [ja|en]
# Run it once for the Japanese site and once for the English one (<site-dir>/en, <hosting-base-path>/en, en).
set -eu

site="$1"
base="/$2/tutorials/appfeature"
lang="${3:-ja}"

if [ "$lang" = en ]; then
  moved_title="Moved"
  moved_text="This tutorial has moved to"
  entry_text="Go to"
else
  moved_title="移動しました"
  moved_text="このチュートリアルは次の場所に移動しました:"
  entry_text="次のページへ移動します:"
fi

redirect() {
  dir="$site/tutorials/appfeature/$1"
  mkdir -p "$dir"
  cat > "$dir/index.html" <<HTML
<!doctype html>
<html lang="$lang">
<head>
<meta charset="utf-8">
<title>$moved_title</title>
<link rel="canonical" href="$base/$2/">
<meta http-equiv="refresh" content="0; url=$base/$2/">
<script>location.replace("$base/$2/" + location.hash);</script>
</head>
<body><p>$moved_text <a href="$base/$2/">$base/$2/</a></p></body>
</html>
HTML
}

redirect 01-sirikit-limits 01-sirikit-to-app-intents
redirect 04-apple-intelligence-siri-ai 06-apple-intelligence-context
redirect 05-siri-ai-tool-intent 07-siri-ai-tools

# /tutorials/ を入口のURLにする。DocCは /tutorials/<名前>/ にしかページを作れないので、ここから目次ページへ転送する
entry="/$2/tutorials/siriaitutorials/"
mkdir -p "$site/tutorials"
cat > "$site/tutorials/index.html" <<HTML
<!doctype html>
<html lang="$lang">
<head>
<meta charset="utf-8">
<title>Siri AI Tutorials</title>
<link rel="canonical" href="$entry">
<meta http-equiv="refresh" content="0; url=$entry">
<script>location.replace("$entry" + location.hash);</script>
</head>
<body><p>$entry_text <a href="$entry">Siri AI Tutorials</a></p></body>
</html>
HTML
