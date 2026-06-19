#!/usr/bin/env python3
"""One-time docx -> markdown migration for docs/manuals/.

Standard library only (no pandoc / python-docx needed). Maps the styles used by
the v6.1 manuals: Heading1/Heading2 -> headings, ListBullet -> bullets,
CodeBlock -> fenced code, and w:tbl -> GitHub markdown tables.

After migration the .md files are the source of truth (see SOURCE-OF-TRUTH.md);
the .docx are kept as the last rendered artifact.

Usage: python3 scripts/docx_to_md.py path/to/file.docx [...]
"""
import sys
import zipfile
import xml.etree.ElementTree as ET

W = '{http://schemas.openxmlformats.org/wordprocessingml/2006/main}'


def ptext(p):
    out = []
    for n in p.iter():
        if n.tag == W + 't':
            out.append(n.text or '')
        elif n.tag == W + 'tab':
            out.append('\t')
        elif n.tag == W + 'br':
            out.append('\n')
    return ''.join(out)


def pstyle(p):
    pPr = p.find(W + 'pPr')
    if pPr is None:
        return ''
    ps = pPr.find(W + 'pStyle')
    return ps.get(W + 'val') if ps is not None else ''


def table_md(tbl):
    rows = []
    for tr in tbl.findall(W + 'tr'):
        cells = []
        for tc in tr.findall(W + 'tc'):
            txt = ' '.join(ptext(p).strip() for p in tc.findall(W + 'p') if ptext(p).strip())
            cells.append(txt.replace('|', '\\|').replace('\n', ' ').strip())
        rows.append(cells)
    rows = [r for r in rows if any(c for c in r)]
    if not rows:
        return ''
    ncol = max(len(r) for r in rows)
    rows = [r + [''] * (ncol - len(r)) for r in rows]
    if ncol == 1:
        # single-cell callout box -> blockquote, not a one-column table
        return '\n'.join('> ' + r[0].strip() for r in rows if r[0].strip())
    lines = ['| ' + ' | '.join(rows[0]) + ' |',
             '| ' + ' | '.join(['---'] * ncol) + ' |']
    for r in rows[1:]:
        lines.append('| ' + ' | '.join(r) + ' |')
    return '\n'.join(lines)


def convert(path):
    z = zipfile.ZipFile(path)
    root = ET.fromstring(z.read('word/document.xml'))
    body = root.find(W + 'body')

    blocks, list_buf, code_buf = [], [], []
    title_done = False

    def flush_list():
        if list_buf:
            blocks.append('\n'.join(list_buf))
            list_buf.clear()

    def flush_code():
        if code_buf:
            blocks.append('```\n' + '\n'.join(code_buf).rstrip() + '\n```')
            code_buf.clear()

    for child in body:
        if child.tag == W + 'tbl':
            flush_list()
            flush_code()
            md = table_md(child)
            if md:
                blocks.append(md)
            continue
        if child.tag != W + 'p':
            continue
        style = pstyle(child)
        txt = ptext(child).rstrip()
        s = txt.strip()
        if style == 'CodeBlock':
            flush_list()
            code_buf.append(txt)
            continue
        flush_code()
        if style == 'ListBullet':
            if s:
                list_buf.append('- ' + s)
            continue
        flush_list()
        if not s:
            continue
        if not title_done:
            blocks.append('# ' + s.replace('\n', ' '))
            title_done = True
            continue
        if style == 'Heading1':
            blocks.append('## ' + s.replace('\n', ' '))
        elif style == 'Heading2':
            blocks.append('### ' + s.replace('\n', ' '))
        else:
            blocks.append(s)

    flush_list()
    flush_code()
    return '\n\n'.join(blocks).strip() + '\n'


if __name__ == '__main__':
    for path in sys.argv[1:]:
        out = path.rsplit('.', 1)[0] + '.md'
        md = convert(path)
        with open(out, 'w', encoding='utf-8') as f:
            f.write(md)
        print(f'wrote {out} ({len(md)} chars)')
