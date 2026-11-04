#!/usr/bin/env python3
"""Generate the siri-ai skill's reference files from the DocC tutorial.

Reads every chapter .tutorial file and the *.seq code sources, and writes:
    references/NN-<chapter>.md   one file per chapter: intro, sections, steps,
                                 the code at the end of each section, and the
                                 workshop prompt
    references/code/<file>       the final version of every code file
The output directory holds generated files only; every run deletes it first.
SKILL.md next to it is written by hand and is left alone.

    python3 tools/skill/generate.py           regenerate
    python3 tools/skill/generate.py --check   exit 1 if the output is stale
"""

import importlib.util
import pathlib
import re
import shutil
import sys
import tempfile

ROOT = pathlib.Path(__file__).resolve().parents[2]
TUTORIALS = ROOT / "ios/Library/Sources/AppFeature/AppFeature.docc/Tutorials"
ART = TUTORIALS / "TutorialArt"
SEQ = ROOT / "tools/tutorial-code/seq"
SKILL = ROOT / "plugins/siri-ai/skills/siri-ai"
OUT = SKILL / "references"
SITE = "https://akidon0000.github.io/siri-ai-tutorials/tutorials/appfeature"

_spec = importlib.util.spec_from_file_location(
    "tutorial_code", ROOT / "tools/tutorial-code/generate.py")
tutorial_code = importlib.util.module_from_spec(_spec)
_spec.loader.exec_module(tutorial_code)

OPEN = re.compile(r"^@(\w+)(?:\((.*)\))?\s*\{$")
LEAF = re.compile(r"^@(\w+)(?:\((.*)\))?$")
ARG = re.compile(r'(\w+):\s*"([^"]*)"')
FENCE = {"swift": "swift", "md": "markdown", "txt": "text"}


class Node:
    def __init__(self, kind, args=""):
        self.kind = kind
        self.args = dict(ARG.findall(args or ""))
        self.raw_args = args or ""
        self.children = []
        self.text = []

    def find(self, kind):
        return [c for c in self.children if c.kind == kind]


def parse_tutorial(path):
    root = Node("root")
    stack = [root]
    for number, raw in enumerate(path.read_text().splitlines(), 1):
        line = raw.strip()
        if line == "}":
            stack.pop()
            continue
        m = OPEN.match(line)
        if m:
            node = Node(m.group(1), m.group(2))
            stack[-1].children.append(node)
            stack.append(node)
            continue
        m = LEAF.match(line)
        if m:
            stack[-1].children.append(Node(m.group(1), m.group(2)))
            continue
        stack[-1].text.append(line)
    if len(stack) != 1:
        sys.exit(f"{path.name}: unbalanced braces")
    return root


def needs_space(a, b):
    """DocC turns a line break into a space; keep it unless both sides are Japanese."""
    if a[-1] in "。、）」":
        return False
    return a[-1].isascii() or b[0].isascii()


def paragraphs(lines):
    """Join DocC's hard-wrapped lines back into paragraphs."""
    out, current = [], ""
    for line in lines + [""]:
        if not line:
            if current:
                out.append(current)
            current = ""
        elif not current:
            current = line
        else:
            current += (" " if needs_space(current, line) else "") + line
    return out


def load_code():
    """Map snapshot file name -> (display name, ext, text) for every step."""
    code = {}
    finals = {}
    for path in sorted(SEQ.glob("*.seq")):
        stem, ext = path.stem.rsplit(".", 1)
        name, lines = tutorial_code.parse(path)
        last = max(max(s, e or s) for s, e, _ in lines)
        for step in range(1, last + 1):
            text = "\n".join(tutorial_code.snapshot(lines, step)) + "\n"
            code[f"{stem}-{step:02d}.{ext}"] = (name, text)
        finals[name] = (stem, ext, code[f"{stem}-{last:02d}.{ext}"][1])
    return code, finals


def fence(name, text):
    ext = name.rsplit(".", 1)[-1]
    body = text.rstrip("\n")
    ticks = "````" if "```" in body else "```"
    return f"{ticks}{FENCE.get(ext, '')}\n{body}\n{ticks}"


def render_chapter(path, chapter_title, code):
    tutorial = parse_tutorial(path).find("Tutorial")[0]
    intro = tutorial.find("Intro")[0]
    slug = path.stem
    out = [
        f"# {chapter_title}",
        "",
        f"所要時間の目安: {tutorial.raw_args.split(':')[-1].strip()}分。"
        f"公開版: {SITE}/{slug}",
        "",
        f"## {intro.args['title']}",
        "",
    ]
    out += [p + "\n" for p in paragraphs(intro.text)]

    for section in tutorial.find("Section"):
        title = section.args["title"]
        out += [f"## {title}", ""]
        for media in section.find("ContentAndMedia"):
            out += [p + "\n" for p in paragraphs(media.text)]
        shown = {}
        prompts = []
        steps = [s for block in section.find("Steps") for s in block.find("Step")]
        for number, step in enumerate(steps, 1):
            refs = []
            for ref in step.find("Code"):
                file = ref.args["file"]
                if file in code:
                    name, text = code[file]
                    shown[name] = (file, text)
                    refs.append(f"`{name}`")
                else:
                    prompts.append(file)
            text = " ".join(paragraphs(step.text))
            suffix = f" — コード: {', '.join(refs)}" if refs else ""
            out.append(f"{number}. {text}{suffix}")
        out.append("")
        if shown:
            out += ["### このセクションを終えた時点のコード", ""]
            for name, (file, text) in shown.items():
                out += [f"`{name}`", "", fence(name, text), ""]
        for file in prompts:
            prompt = (ART / file).read_text()
            out += [
                "### ワークショップ用プロンプト",
                "",
                "チュートリアルのリポジトリ（akidon0000/siri-ai-tutorials）を clone した上で",
                "Claude Code に渡すためのもの。自分のアプリで進めるときは、パスとターゲット名を読み替える。",
                "",
                fence("prompt.txt", prompt),
                "",
            ]
    return "\n".join(out).rstrip("\n") + "\n"


def chapters():
    """(chapter title, tutorial file) in book order."""
    book = parse_tutorial(TUTORIALS / "SiriAITutorials.tutorial").find("Tutorials")[0]
    result = []
    for chapter in book.find("Chapter"):
        ref = chapter.find("TutorialReference")[0].args["tutorial"]
        result.append((chapter.args["name"], TUTORIALS / f"{ref.removeprefix('doc:')}.tutorial"))
    return result


def build(out):
    code, finals = load_code()
    out.mkdir(parents=True)
    for title, path in chapters():
        (out / f"{path.stem}.md").write_text(render_chapter(path, title, code))
    (out / "code").mkdir()
    for name, (stem, ext, text) in sorted(finals.items()):
        (out / "code" / f"{stem}.{ext}").write_text(text)


def same_tree(a, b):
    files_a = sorted(p.relative_to(a) for p in a.rglob("*") if p.is_file())
    files_b = sorted(p.relative_to(b) for p in b.rglob("*") if p.is_file())
    if files_a != files_b:
        return False
    return all((a / f).read_bytes() == (b / f).read_bytes() for f in files_a)


def main():
    if "--check" in sys.argv[1:]:
        with tempfile.TemporaryDirectory() as tmp:
            fresh = pathlib.Path(tmp) / "references"
            build(fresh)
            if not OUT.exists() or not same_tree(fresh, OUT):
                sys.exit("plugins/siri-ai/skills/siri-ai/references is stale; "
                         "run python3 tools/skill/generate.py")
        print("skill references are up to date")
        return
    if OUT.exists():
        shutil.rmtree(OUT)
    build(OUT)
    print(f"wrote {sum(1 for p in OUT.rglob('*') if p.is_file())} files to {OUT.relative_to(ROOT)}")


if __name__ == "__main__":
    main()
