#!/usr/bin/env python3
"""Generate per-step code snapshots for the DocC tutorial from *.seq sources.

Each line of a .seq file starts with a step tag:
    N|text      the line exists from step N onward
    N-M|text    the line exists from step N through step M (removed at M+1)
A header line `#name Display.swift` sets the name used by @Code(name:).

Output: one file per step, <seq-stem>-NN.<ext>, in the tutorial Code directory.
That directory holds generated files only; every run deletes its contents first.
The script also checks every .tutorial file so that each @Code reference
points at an existing snapshot, uses the sequence's display name, and names
the immediately preceding snapshot as previousFile.
"""

import pathlib
import re
import sys

ROOT = pathlib.Path(__file__).resolve().parents[2]
SRC = pathlib.Path(__file__).resolve().parent / "seq"
CATALOG = ROOT / "ios/Library/Sources/AppFeature/AppFeature.docc"
OUT = CATALOG / "Tutorials/TutorialArt/Code"
# Lines added per step: at most 5 excluding blank, bracket-only and
# comment-only lines, and at most 6 non-blank lines counting brackets.
# Comments explain the code, so they never count toward the limits.
MAX_ADDED = 5
TAG = re.compile(r"^(\d+)(?:-(\d+))?\|(.*)$")


def is_comment(line):
    return line.strip().startswith("//")


def counts_as_code(line):
    stripped = line.strip()
    return (bool(stripped) and not is_comment(line)
            and not re.fullmatch(r"[\}\)\]]+[,;]?", stripped))


def parse(path):
    name = None
    lines = []
    for raw in path.read_text().splitlines():
        if raw.startswith("#name "):
            name = raw[len("#name "):].strip()
            continue
        m = TAG.match(raw)
        if not m:
            sys.exit(f"{path.name}: untagged line: {raw!r}")
        start = int(m.group(1))
        end = int(m.group(2)) if m.group(2) else None
        lines.append((start, end, m.group(3)))
    if name is None:
        sys.exit(f"{path.name}: missing #name header")
    return name, lines


def snapshot(lines, step):
    return [t for s, e, t in lines if s <= step and (e is None or step <= e)]


def main():
    OUT.mkdir(parents=True, exist_ok=True)
    for old in OUT.iterdir():
        old.unlink()

    names = {}
    errors = []
    for path in sorted(SRC.glob("*.seq")):
        stem, ext = path.stem.rsplit(".", 1)
        name, lines = parse(path)
        last = max(max(s, e or s) for s, e, _ in lines)
        previous = []
        for step in range(1, last + 1):
            current = snapshot(lines, step)
            added = [t for s, _, t in lines if s == step and counts_as_code(t)]
            if len(added) > MAX_ADDED:
                errors.append(f"{path.name} step {step}: {len(added)} lines added")
            nonblank = [t for s, _, t in lines if s == step and t.strip() and not is_comment(t)]
            if len(nonblank) > MAX_ADDED + 1:
                errors.append(f"{path.name} step {step}: {len(nonblank)} non-blank lines added")
            if step > 1 and current == previous:
                errors.append(f"{path.name} step {step}: no change")
            out = OUT / f"{stem}-{step:02d}.{ext}"
            out.write_text("\n".join(current) + "\n")
            names[out.name] = (name, f"{stem}-{step - 1:02d}.{ext}" if step > 1 else None)
            previous = current
        print(f"{path.name}: {last} steps")

    code_ref = re.compile(r"@Code\(([^)]*)\)")
    arg = re.compile(r'(\w+):\s*"([^"]*)"')
    unused = set(names)
    for tutorial in sorted((CATALOG / "Tutorials").glob("*.tutorial")):
        for m in code_ref.finditer(tutorial.read_text()):
            args = dict(arg.findall(m.group(1)))
            file = args.get("file", "")
            if file not in names:
                continue
            unused.discard(file)
            name, prev = names[file]
            if args.get("name") != name:
                errors.append(f"{tutorial.name}: {file} should use name {name!r}")
            if args.get("previousFile") != prev:
                errors.append(f"{tutorial.name}: {file} should use previousFile {prev!r}")
    errors += [f"{file}: not referenced by any step" for file in sorted(unused)]

    if errors:
        print("\n".join(errors))
        sys.exit(1)


if __name__ == "__main__":
    main()
