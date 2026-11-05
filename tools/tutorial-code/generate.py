#!/usr/bin/env python3
"""Generate per-step code snapshots for the DocC tutorial from *.seq sources.

Each line of a .seq file starts with a step tag:
    N|text      the line exists from step N onward
    N-M|text    the line exists from step N through step M (removed at M+1)
A header line `#name Display.swift` sets the name used by @Code(name:).

Output: one file per step, <seq-stem>-NN.<ext>, in the Code directory of each
DocC catalog: the Japanese catalog (the .seq text as is) and the English
catalog (the .seq text with every line that contains Japanese replaced through
en/<seq-stem>.<ext>.en). Those directories hold generated files only; every
run deletes their contents first.

An .en file lists pairs of lines:
    ja|<a .seq line containing Japanese, without its tag and indentation>
    en|<the English line that replaces it; the indentation is kept>
Every Japanese line needs a pair, every pair must be used, and the English
side must not contain Japanese.

The script also checks every .tutorial file of both catalogs so that each
@Code reference points at an existing snapshot, uses the sequence's display
name, and names the immediately preceding snapshot as previousFile, and that
the English catalog has the same tutorials, directives (sections, steps, code,
images, references) and TutorialArt files as the Japanese one.
"""

import pathlib
import re
import sys

ROOT = pathlib.Path(__file__).resolve().parents[2]
SRC = pathlib.Path(__file__).resolve().parent / "seq"
EN = pathlib.Path(__file__).resolve().parent / "en"
CATALOG = ROOT / "ios/Library/Sources/AppFeature/AppFeature.docc"
EN_CATALOG = ROOT / "ios/Library/Documentation/en/AppFeature.docc"
# Lines added per step: at most 5 excluding blank, bracket-only and
# comment-only lines, and at most 6 non-blank lines counting brackets.
# Comments explain the code, so they never count toward the limits.
MAX_ADDED = 5
TAG = re.compile(r"^(\d+)(?:-(\d+))?\|(.*)$")
JAPANESE = re.compile(r"[\u3000-\u30ff\u3400-\u9fff\uff00-\uffef]")


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


def code_dir(catalog):
    return catalog / "Tutorials/TutorialArt/Code"


def load_table(path, errors):
    """Read an .en file into {Japanese line: English line}."""
    table = {}
    pending = None
    for number, raw in enumerate(path.read_text().splitlines(), 1):
        if raw.startswith("ja|"):
            pending = raw[3:].strip()
        elif raw.startswith("en|") and pending is not None:
            english = raw[3:].strip()
            if JAPANESE.search(english):
                errors.append(f"{path.name}:{number}: English side contains Japanese")
            table[pending] = english
            pending = None
        elif raw.strip():
            errors.append(f"{path.name}:{number}: expected a ja| line followed by an en| line")
    return table


def translate(path, lines, errors):
    """Replace every line containing Japanese with its English pair."""
    table_path = EN / f"{path.stem}.en"
    japanese = {t.strip() for _, _, t in lines if JAPANESE.search(t)}
    if not japanese and not table_path.exists():
        return lines
    if not table_path.exists():
        errors.append(f"{path.name}: missing {table_path.relative_to(ROOT)}")
        return lines
    table = load_table(table_path, errors)
    for key in sorted(japanese - table.keys()):
        errors.append(f"{table_path.name}: no English for {key!r}")
    for key in sorted(table.keys() - japanese):
        errors.append(f"{table_path.name}: unused entry {key!r}")
    out = []
    for s, e, t in lines:
        key = t.strip()
        if key in japanese and key in table:
            t = t[:len(t) - len(t.lstrip())] + table[key]
        out.append((s, e, t))
    return out


def structure(text):
    """The directives of a .tutorial in order, with the arguments that must not be translated."""
    keep = re.compile(r'(file|previousFile|source|tutorial):\s*"([^"]*)"')
    out = []
    for m in re.finditer(r"@(\w+)(\(([^)]*)\))?", text):
        out.append((m.group(1),) + tuple(keep.findall(m.group(3) or "")))
    return out


def check_translation(errors):
    """The English catalog must mirror the Japanese one except for the prose."""
    files = {}
    for catalog in (CATALOG, EN_CATALOG):
        files[catalog] = {p.relative_to(catalog) for p in catalog.rglob("*")
                          if p.is_file() and "Code" not in p.relative_to(catalog).parts}
    for rel in sorted(files[CATALOG] ^ files[EN_CATALOG]):
        where = "English" if rel in files[CATALOG] else "Japanese"
        errors.append(f"{rel}: missing from the {where} catalog")
    for rel in sorted(files[CATALOG] & files[EN_CATALOG]):
        if rel.suffix != ".tutorial":
            continue
        ja = structure((CATALOG / rel).read_text())
        en = structure((EN_CATALOG / rel).read_text())
        if ja != en:
            at = next((i for i, (a, b) in enumerate(zip(ja, en)) if a != b), min(len(ja), len(en)))
            errors.append(f"{rel}: English directives differ from Japanese at #{at + 1}: "
                          f"{ja[at] if at < len(ja) else None} vs {en[at] if at < len(en) else None}")


def main():
    catalogs = [CATALOG, EN_CATALOG]
    for catalog in catalogs:
        out = code_dir(catalog)
        out.mkdir(parents=True, exist_ok=True)
        for old in out.iterdir():
            old.unlink()

    names = {}
    errors = []
    for table_path in sorted(EN.glob("*.en")):
        if not (SRC / f"{table_path.stem}.seq").exists():
            errors.append(f"{table_path.name}: no matching .seq")
    for path in sorted(SRC.glob("*.seq")):
        stem, ext = path.stem.rsplit(".", 1)
        name, lines = parse(path)
        english = translate(path, lines, errors)
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
            file = f"{stem}-{step:02d}.{ext}"
            (code_dir(CATALOG) / file).write_text("\n".join(current) + "\n")
            (code_dir(EN_CATALOG) / file).write_text("\n".join(snapshot(english, step)) + "\n")
            names[file] = (name, f"{stem}-{step - 1:02d}.{ext}" if step > 1 else None)
            previous = current
        print(f"{path.name}: {last} steps")

    code_ref = re.compile(r"@Code\(([^)]*)\)")
    arg = re.compile(r'(\w+):\s*"([^"]*)"')
    for catalog in catalogs:
        label = catalog.relative_to(ROOT)
        unused = set(names)
        for tutorial in sorted((catalog / "Tutorials").glob("*.tutorial")):
            for m in code_ref.finditer(tutorial.read_text()):
                args = dict(arg.findall(m.group(1)))
                file = args.get("file", "")
                if file not in names:
                    continue
                unused.discard(file)
                name, prev = names[file]
                if args.get("name") != name:
                    errors.append(f"{label}/{tutorial.name}: {file} should use name {name!r}")
                if args.get("previousFile") != prev:
                    errors.append(f"{label}/{tutorial.name}: {file} should use previousFile {prev!r}")
        errors += [f"{label}: {file} not referenced by any step" for file in sorted(unused)]
    check_translation(errors)

    if errors:
        print("\n".join(errors))
        sys.exit(1)


if __name__ == "__main__":
    main()
