#!/usr/bin/env python3
"""Make room for a new step in a .seq file.

    python3 tools/tutorial-code/shift.py <seq-stem> <N> [count]

Every step number >= N in seq/<seq-stem>.seq is increased by `count`
(default 1), and every @Code(file:/previousFile:) reference to those
snapshots in the .tutorial files is renumbered the same way. Afterwards,
add the new lines tagged N| and reference <stem>-NN from the tutorial.
"""

import pathlib
import re
import sys

ROOT = pathlib.Path(__file__).resolve().parents[2]
SEQ = pathlib.Path(__file__).resolve().parent / "seq"
TUTORIALS = ROOT / "ios/Library/Sources/AppFeature/AppFeature.docc/Tutorials"


def main():
    if len(sys.argv) not in (3, 4):
        sys.exit(__doc__)
    seq_stem, first = sys.argv[1], int(sys.argv[2])
    count = int(sys.argv[3]) if len(sys.argv) == 4 else 1
    path = SEQ / f"{seq_stem}.seq"
    stem, ext = seq_stem.rsplit(".", 1)

    def bump(n):
        return n + count if n >= first else n

    def retag(m):
        start = bump(int(m.group(1)))
        end = f"-{bump(int(m.group(2)))}" if m.group(2) else ""
        return f"{start}{end}|"

    path.write_text(re.sub(r"(?m)^(\d+)(?:-(\d+))?\|", retag, path.read_text()))

    ref = re.compile(rf'"{re.escape(stem)}-(\d+)\.{re.escape(ext)}"')
    for tutorial in TUTORIALS.glob("*.tutorial"):
        text = tutorial.read_text()
        new = ref.sub(lambda m: f'"{stem}-{bump(int(m.group(1))):02d}.{ext}"', text)
        if new != text:
            tutorial.write_text(new)


if __name__ == "__main__":
    main()
