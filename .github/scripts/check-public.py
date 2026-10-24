#!/usr/bin/env python3
"""Pre-publish checks for the public 7fchain tree.

Usage: check-public.py <public-github dir> <paper-slug>...

Checks the files publish-public-github.sh copies (README.md, SECURITY.md,
docs/*.md, papers/README.md and the named papers):

  links    every relative link resolves to a published file, and every
           #anchor to a heading in it (GitHub's slug rules);
  wording  README, SECURITY and docs carry no product-status wording such as
           "planned" or "coming soon": everything is described as working.
           Papers have their own review, so wording is not checked there;
  html     no bare <placeholder> outside code, which GitHub would swallow;
  mermaid  every ```mermaid block renders, when mmdc is installed.

Exits 1 on any failure. The source of this file is internal; the copy in the
public repo's .github/scripts/ is overwritten on every publish and run by the
Docs checks workflow.
"""
import json
import os
import re
import shutil
import subprocess
import sys
import tempfile

BANNED = re.compile(
    r"\b(planned|coming soon|not yet (?:live|available|supported|built)|roadmap|"
    r"in development|under development|work in progress|TBD|TODO|"
    r"will be (?:available|added|supported|released)|when it launches|"
    r"(?:not|isn't|is not) live|in a future release|eventually)\b",
    re.IGNORECASE,
)
ALLOWED_TAGS = {"br", "details", "summary", "sup", "sub", "kbd", "a", "img", "p", "b", "i"}
FENCE = re.compile(r"^```.*?^```[^\n]*$", re.MULTILINE | re.DOTALL)
CODE_SPAN = re.compile(r"`[^`\n]*`")
LINK = re.compile(r"\]\(([^)\s]+)\)")


def slug(heading):
    text = re.sub(r"[^\w\- ]", "", heading.strip().lower())
    return text.replace(" ", "-")


def anchors(path):
    found, seen = set(), {}
    in_fence = False
    for line in open(path, encoding="utf-8"):
        if line.startswith("```"):
            in_fence = not in_fence
            continue
        m = None if in_fence else re.match(r"#+\s+(.*)", line)
        if m:
            s = slug(m.group(1))
            n = seen.get(s, 0)
            found.add(s if n == 0 else f"{s}-{n}")
            seen[s] = n + 1
    return found


def prose(text):
    """Text with fenced blocks and code spans removed, line numbers kept."""
    text = FENCE.sub(lambda m: "\n" * m.group(0).count("\n"), text)
    return CODE_SPAN.sub("", text)


def line_of(text, pos):
    return text.count("\n", 0, pos) + 1


def check_links(path, text, published, errors):
    for m in LINK.finditer(text):
        url = m.group(1)
        if url.startswith(("http://", "https://", "mailto:")):
            continue
        target, _, frag = url.partition("#")
        dest = os.path.normpath(os.path.join(os.path.dirname(path), target)) if target else path
        where = f"{path}:{line_of(text, m.start())}"
        if dest.rstrip("/") in {"docs", "papers", "."}:
            continue
        if dest not in published:
            errors.append(f"{where}: link to unpublished or missing file: {url}")
        elif frag and dest.endswith(".md") and frag not in anchors(dest):
            errors.append(f"{where}: no heading for anchor: {url}")


def check_prose(path, text, check_wording, errors):
    body = prose(text)
    for m in re.finditer(r"<(/?)([a-zA-Z][\w-]*)[^>\n]*>", body):
        if m.group(2).lower() not in ALLOWED_TAGS:
            errors.append(f"{path}:{line_of(body, m.start())}: <{m.group(2)}> outside code is hidden by GitHub; put it in backticks")
    if check_wording:
        for m in BANNED.finditer(body):
            errors.append(f"{path}:{line_of(body, m.start())}: product-status wording \"{m.group(0)}\"")


def check_mermaid(files, errors):
    blocks = [(p, m) for p in files for m in re.findall(r"```mermaid\n(.*?)```", open(p, encoding="utf-8").read(), re.S)]
    mmdc = shutil.which("mmdc")
    if blocks and not mmdc:
        print(f"warning: mmdc not installed; {len(blocks)} Mermaid diagram(s) not render-checked", file=sys.stderr)
        return len(blocks)
    with tempfile.TemporaryDirectory() as tmp:
        # Ubuntu 24.04 blocks unprivileged user namespaces, so headless Chrome
        # can't start its sandbox. The diagrams are our own, so skip it.
        puppeteer = os.path.join(tmp, "puppeteer.json")
        with open(puppeteer, "w") as f:
            json.dump({"args": ["--no-sandbox"]}, f)
        for i, (path, src) in enumerate(blocks):
            mmd, out = os.path.join(tmp, f"{i}.mmd"), os.path.join(tmp, f"{i}.svg")
            with open(mmd, "w") as f:
                f.write(src)
            run = subprocess.run([mmdc, "-q", "-p", puppeteer, "-i", mmd, "-o", out], capture_output=True, text=True)
            if run.returncode != 0:
                first = run.stderr.strip().splitlines()[0] if run.stderr.strip() else "unknown error"
                errors.append(f"{path}: Mermaid diagram does not render: {first}")
    return len(blocks)


def main():
    if len(sys.argv) < 2:
        sys.exit(__doc__)
    root, papers = sys.argv[1], sys.argv[2:]
    os.chdir(root)
    status_files = ["README.md", "SECURITY.md"] + sorted(
        f"docs/{f}" for f in os.listdir("docs") if f.endswith(".md")
    )
    paper_files = ["papers/README.md"] + [f"papers/{p}.md" for p in papers]
    published = {os.path.normpath(f) for f in status_files + paper_files}
    errors = []

    for path in status_files + paper_files:
        if not os.path.exists(path):
            errors.append(f"{path}: missing")
            continue
        text = open(path, encoding="utf-8").read()
        check_links(path, text, published, errors)
        check_prose(path, text, path in status_files, errors)
    diagrams = check_mermaid(status_files, errors)

    for e in errors:
        print(f"check-public: {e}", file=sys.stderr)
    print(f"check-public: {len(published)} files, {diagrams} diagrams, {len(errors)} problem(s)")
    sys.exit(1 if errors else 0)


if __name__ == "__main__":
    main()
