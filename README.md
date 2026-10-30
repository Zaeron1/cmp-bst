# cmp.bst

A BibTeX style for the reference format of **Contributions to Mineralogy and
Petrology (CMP)** (Springer "Basic" author–year convention), for use with
[`natbib`](https://ctan.org/pkg/natbib).

CMP is not shipped as a ready-made style in standard LaTeX distributions. Springer Nature's journal template
provides a generic Springer Basic style (`sn-basic.bst`), but it is tied to that template's document class.
`cmp.bst` is a standalone alternative that works with **any** class (articles, theses, reports, posters) and
follows the CMP conventions (`Surname INITIALS`, abbreviated journal names, DOI links). Drop it next to your `.tex`
file and BibTeX does the formatting for you.

```
Silver L, Stolper E (1989) Water in albitic glasses. J Petrol 30(3):667–709.
   https://doi.org/10.1093/petrology/30.3.667

Roberti G, Roberts NJ, Lit C (2021) Climatic influence on volcanic landslides. In: Roverato M,
   Dufresne A, Procter J (eds) Volcanic Debris Avalanches. Springer, Cham, pp 121–141
```

In the text: `(Silver and Stolper 1989)`, `Silver and Stolper (1989)`,
`(Gualda et al. 2012; Ghiorso and Gualda 2015)`.

## Quick start

1. Copy [`cmp.bst`](cmp.bst) into your project folder (on Overleaf: *Upload* → `cmp.bst`).
2. In your preamble and at the end of the document:

```latex
\usepackage{natbib}
\bibpunct{(}{)}{;}{a}{}{,~}      % (Author 2020; Author and Author 2021)

...

\bibliographystyle{cmp}
\bibliography{references}        % references.bib
```

3. Cite with `\citep{key}` → *(Silver and Stolper 1989)*, `\citet{key}` → *Silver and Stolper (1989)*,
   `\citep[p.~3]{key}` → *(Silver and Stolper 1989, p. 3)*.
4. Compile the usual way: `pdflatex` → `bibtex` → `pdflatex` → `pdflatex`
   (or just let Overleaf / `latexmk` do it).

A complete working example is in [`example/`](example/) (`example.tex`, `references.bib`, `example.pdf`).

> This style needs **BibTeX + natbib**. It is not compatible with `biblatex`/`biber`.

## What it does

- Author–year labels, authors written `Surname INITIALS` (`Lénat JF`, `van der Berg J`, `Jones M Jr`).
- Journal names abbreviated when a `shortjournal` field exists (no dots: `J Petrol`, `Contrib Mineral Petrol`).
- Volume(issue):pages with an en dash, article numbers (`eid`) supported.
- DOI printed as `https://doi.org/...` (any of `10.xxx`, `doi:10.xxx`, `https://doi.org/10.xxx` is accepted); URL and
  access date for web resources.
- Chapters in edited books in Springer order: `In: Editors (eds) Book title. Publisher, City, pp 1–10`.
- Same author(s) and year → `2020a`, `2020b`.
- Accent-insensitive sorting (`Lénat` before `Lenoir`).
- Empty fields never leave stray punctuation.

### Entry types

`article`, `book` (+ `collection`, `mvbook`, `reference`), `incollection`, `inbook`, `inreference`,
`inproceedings` (+ `conference`), `proceedings`, `phdthesis`, `mastersthesis`, `thesis`,
`techreport` (+ `report`), `manual`, `booklet`, `online` (+ `website`, `webpage`, `www`, `electronic`),
`dataset`, `software`, `standard`, `legislation`, `map`, `patent`, `unpublished`, `misc`.

Field names are the standard BibTeX/biblatex ones, i.e. what Zotero, Mendeley or JabRef export. The full list
is documented at the top of [`cmp.bst`](cmp.bst).

Tips:
- Corporate authors go in double braces: `author = {{BRGM}}`.
- Put the abbreviated journal name in `shortjournal` (Zotero: *Journal Abbr*). If missing, the full `journal` is used.
- Page ranges can be written `667-709`; the style converts them to an en dash.

## Options

At the top of `cmp.bst`, a few switches (change `#0` / `#1`):

| Option | Default | Effect |
|---|---|---|
| `cfg.max.names` | `#0` | Max. authors listed before "et al." in the reference list (`#0` = all) |
| `cfg.show.issue` | `#1` | Print the issue number: `30(3):667–709` (`#0` → `30:667–709`) |
| `cfg.show.isbn` | `#0` | Print ISBNs |
| `cfg.short.journal` | `#1` | Use `shortjournal` when available |
| `cfg.url.with.doi` | `#0` | Also print the URL when a DOI exists |

## Other languages

All words written by the style (*and*, *In:*, *eds*, *edn*, *Accessed*, month names, *Dissertation*...) are LaTeX macros
defined in English by default. To localise them, redefine the macros in your preamble **before** `\bibliography`
(`\newcommand` works because the style only uses `\providecommand`):

```latex
\newcommand{\biband}{und}
\newcommand{\bibin}{In:}
\newcommand{\bibeds}{(Hrsg.)}
% ... \bibetal \bibed \bibedition \bibvol \bibchap \bibpp \bibp \bibtotalpages \bibonline
%     \bibaccessed \bibdate \bibnodate \bibphdthesis \bibmastersthesis \bibthesis
%     \bibtechreport \bibpatent \bibsheet \bibno \bibversion \bibdataset \bibsoftware
```

The default definitions are listed at the end of `cmp.bst` (`begin.bib` function).

## Disclaimer

This style implements the CMP / Springer Basic conventions as understood by the author and checked against typical CMP
reference lists. It is **not** an official Springer or CMP product. Always compare the result with the current
[journal instructions for authors](https://link.springer.com/journal/410/submission-guidelines) before submitting, and
please open an issue if you find a difference.

## Testing

`tests/all-types.bib` contains at least one entry per supported type plus edge cases (accents, corporate authors,
missing fields, same-year disambiguation). Some entries are fictional and only serve to exercise the style.

```bash
cd tests && cat > t.tex <<'TEX'
\documentclass{article}\usepackage[utf8]{inputenc}\usepackage[T1]{fontenc}
\usepackage{natbib}\bibpunct{(}{)}{;}{a}{}{,~}
\begin{document}\nocite{*}\bibliographystyle{../cmp}\bibliography{all-types}\end{document}
TEX
pdflatex t && bibtex t && pdflatex t && pdflatex t
```

## License

[MIT](LICENSE) © 2026 Alexandre Michaux. This style is a rewrite of an earlier personal version, itself derived from
`ulg-geoFR.bst`, `agsm.bst` (P. Williams, 1991) and the standard BibTeX styles by O. Patashnik. If you modify
`cmp.bst`, please rename your version.

## Citing

See [`CITATION.cff`](CITATION.cff).
