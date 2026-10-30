%% cmp.bst
%% BibTeX style for Contributions to Mineralogy and Petrology (CMP)
%% (Springer "Basic" author-year convention), for use with natbib.
%%
%% Version 2.1, October 2026
%% Copyright (c) 2026 Alexandre Michaux -- MIT License (see LICENSE).
%%
%% Complete rewrite of an earlier personal version (v1.1, 2025), itself derived
%% from ulg-geoFR.bst, agsm.bst (P. Williams, 1991) and the standard BibTeX
%% styles of O. Patashnik. If you modify this file, please rename it.
%%
%%
%% USAGE
%%   \usepackage{natbib}
%%   \bibpunct{(}{)}{;}{a}{}{,~}
%%   \bibliographystyle{cmp}
%%   ...
%%   \bibliography{references}
%%
%%   \citep{key}    -> (Silver and Stolper 1989)
%%   \citet{key}    -> Silver and Stolper (1989)
%%   \citep{a,b}    -> (Foucault et al. 2020a, b; Silver and Stolper 1989)
%%
%%
%% OUTPUT (CMP / Springer Basic conventions)
%%   Article   Silver L, Stolper E (1989) Water in albitic glasses. J Petrol
%%             30:667--709. https://doi.org/10.1093/petrology/30.3.667
%%   Book      Cojan I, Renard M (2021) Sedimentology. 3rd edn. Dunod, Paris
%%   Chapter   Roberti G, Roberts NJ, Lit C (2021) Climatic influence on volcanic
%%             landslides. In: Roverato M, Dufresne A, Procter J (eds) Volcanic
%%             Debris Avalanches. Springer, Cham, pp 121--141
%%   Thesis    Torrent G (1974) Title. Dissertation. Example University,
%%             Example City
%%   Web       BRGM (n.d.) Geology and subsurface modelling [online].
%%             https://www.brgm.fr/... Accessed 14 November 2025
%%
%%
%% ENTRY TYPES
%%   @article         journal article
%%   @book            book (aliases: @collection, @mvbook, @reference)
%%   @incollection    chapter in an edited book
%%   @inbook          chapter (with booktitle) or part of a single-author book
%%   @inreference     encyclopedia or dictionary article
%%   @inproceedings   conference paper (alias: @conference)
%%   @proceedings     whole proceedings volume
%%   @phdthesis       doctoral dissertation
%%   @mastersthesis   master's thesis
%%   @thesis          other academic work (set type = {...})
%%   @techreport      technical report (alias: @report)
%%   @manual          manual, documentation
%%   @booklet         booklet, document without publisher
%%   @online          web site or page (aliases: @website, @webpage, @www, @electronic)
%%   @dataset         dataset
%%   @software        software, code
%%   @standard        standard (ISO, AFNOR...)
%%   @legislation     legal text (decree, act)
%%   @map             geological map or its explanatory notice
%%   @patent          patent
%%   @unpublished     unpublished work, submitted manuscript
%%   @misc            anything else (default type)
%%
%%
%% RECOGNISED FIELDS (standard BibTeX / biblatex names, as exported by Zotero)
%%   author        authors, "Last, First and Last, First"; an organisation
%%                 goes in double braces: {{BRGM}}
%%   editor        volume editors
%%   organization  corporate author or publisher, web site name
%%   year / date   year, or ISO date (2021 or 2021-03-04)
%%   title         title of article, chapter, book, web page...
%%   booktitle     title of the book, proceedings, encyclopedia
%%   journal       journal name (or journaltitle)
%%   shortjournal  journal abbreviation (used first; give it without dots)
%%   volume, number, pages, eid (article number)
%%   edition       edition number (2, 3...); the 1st is never printed
%%   series        series (Lecture Notes..., Geological Map of France)
%%   publisher     publisher
%%   address       place of publication (or location)
%%   school        university (theses); institution for reports
%%   type          qualifies the type: "Dissertation", "Decree", "NF EN ISO"...
%%   chapter       chapter number (@inbook without booktitle)
%%   pagetotal     total number of pages (books, theses, standards)
%%   eventdate     conference date; venue: conference location
%%   scale         map scale (1:50 000)
%%   version       software or dataset version
%%   howpublished  mode of distribution (@misc, @booklet)
%%   doi           bare DOI (10.xxxx/...) or full (https://doi.org/...)
%%   url, urldate  web address and access date (2025-11-14 or free text)
%%   isbn          printed if option cfg.show.isbn is 1
%%   note          extra information, printed before the DOI/URL
%%   key           sort/cite key when there is no author or organisation
%%
%%   Legacy aliases still accepted: consulteddate (-> urldate),
%%   sitename (-> organization), proceedingdate (-> eventdate).
%%
%%
%% LANGUAGE
%%   All words written by the style (and, In:, eds, edn, Accessed...) are LaTeX
%%   macros (\biband, \bibin, \bibedition...). They default to English at the
%%   top of the .bbl file and can be redefined in the preamble for another
%%   language (see the README).
%%   With babel's French option, the automatic space before ":" is switched off in the
%%   reference list (30:667--709, In:), as the CMP convention requires.
%%
%%
%% SORTING
%%   Alphabetical by first author, then: single author (chronological), two
%%   authors (alphabetical by second author, then chronological), three or more
%%   authors (chronological). Same authors and same year: 2020a, 2020b.


%% Options ---------------------------------------------------------------------
%  Change the number in braces to change the behaviour.

% Maximum number of authors before "et al." in the reference list
% (0 = list all authors).
FUNCTION {cfg.max.names} { #0 }

% Issue number (field number): 1 = shown, J Petrol 30(3):667--709;
% 0 = never shown, volume only (J Petrol 30:667--709).
FUNCTION {cfg.show.issue} { #1 }

% Print the ISBN of books (0 = no; it is optional in CMP).
FUNCTION {cfg.show.isbn} { #0 }

% Use shortjournal when present (1 = yes; CMP abbreviates journal names).
FUNCTION {cfg.short.journal} { #1 }

% Also print the URL when a DOI is present (0 = no).
FUNCTION {cfg.url.with.doi} { #0 }


%% Fields ----------------------------------------------------------------------

ENTRY
  { address author booktitle chapter consulteddate date doi edition editor
    eid eventdate howpublished institution isbn journal journaltitle key
    location note number organization pages pagetotal proceedingdate
    publisher scale school series shortjournal sitename title titleaddon
    type url urldate venue version volume year }
  { name.source }
  { label.short sort.label extra.label the.year list.year }

INTEGERS { started last.url space.next nameptr namesleft numnames maxn multiresult ch
           ind tsslen last.extra.num }

STRINGS { s t next.sep tag istr tss rss ret last.label next.extra }


%% Logic and string helpers --------------------------------------------------

FUNCTION {not} { { #0 } { #1 } if$ }
FUNCTION {and} { 'skip$ { pop$ #0 } if$ }
FUNCTION {or}  { { pop$ #1 } 'skip$ if$ }

FUNCTION {field.or.null}
{ duplicate$ empty$ { pop$ "" } 'skip$ if$ }

% string target replacement replace.substring -> string
FUNCTION {replace.substring}
{ 'rss :=
  'tss :=
  'istr :=
  "" 'ret :=
  tss text.length$ 'tsslen :=
  #1 'ind :=
    { istr ind #1 substring$ "" = not }
    { istr ind tsslen substring$ tss =
        { ret rss * 'ret :=
          ind tsslen + 'ind :=
        }
        { ret istr ind #1 substring$ * 'ret :=
          ind #1 + 'ind :=
        }
      if$
    }
  while$
  ret
}

% True if the string contains digits only.
FUNCTION {is.digits}
{ 't :=
  t empty$
    { #0 }
    { #1 'multiresult :=
        { t empty$ not }
        { t #1 #1 substring$ chr.to.int$ 'ch :=
          ch "0" chr.to.int$ < ch "9" chr.to.int$ > or
            { #0 'multiresult := }
            'skip$
          if$
          t #2 global.max$ substring$ 't :=
        }
      while$
      multiresult
    }
  if$
}

% True if the string contains a hyphen, comma or "+" (page range).
FUNCTION {multi.page.check}
{ 't :=
  #0 'multiresult :=
    { multiresult not t empty$ not and }
    { t #1 #1 substring$
      duplicate$ "-" =
      swap$ duplicate$ "," =
      swap$ "+" =
      or or
        { #1 'multiresult := }
        { t #2 global.max$ substring$ 't := }
      if$
    }
  while$
  multiresult
}

% Replace "-" by "--" (en dash).
FUNCTION {n.dashify}
{ 't :=
  ""
    { t empty$ not }
    { t #1 #1 substring$ "-" =
        { t #1 #2 substring$ "--" = not
            { "--" *
              t #2 global.max$ substring$ 't :=
            }
            {   { t #1 #1 substring$ "-" = }
                { "-" *
                  t #2 global.max$ substring$ 't :=
                }
              while$
            }
          if$
        }
        { t #1 #1 substring$ *
          t #2 global.max$ substring$ 't :=
        }
      if$
    }
  while$
}

% n string chop.word: remove the prefix of length n if present.
FUNCTION {chop.word}
{ 's :=
  'ch :=
  s #1 ch substring$ =
    { s ch #1 + global.max$ substring$ }
    's
  if$
}


%% Fields with fallback values --------------------------------------------------

FUNCTION {get.address}
{ address empty$ { location field.or.null } { address } if$ }

FUNCTION {get.journal}
{ cfg.short.journal shortjournal empty$ not and
    { shortjournal "." "" replace.substring }
    { journal empty$ { journaltitle field.or.null } { journal } if$ }
  if$
}

FUNCTION {get.school}
{ school empty$ { institution field.or.null } { school } if$ }

FUNCTION {get.institution}
{ institution empty$ { school field.or.null } { institution } if$ }

FUNCTION {get.urldate}
{ urldate empty$ { consulteddate field.or.null } { urldate } if$ }

FUNCTION {get.eventdate}
{ eventdate empty$ { proceedingdate field.or.null } { eventdate } if$ }

FUNCTION {get.pages}
{ pages empty$ { eid field.or.null } { pages } if$ }

% Site or publishing body name, if it is not already the author.
FUNCTION {get.site}
{ name.source #3 = organization empty$ or
    { sitename empty$ { titleaddon field.or.null } { sitename } if$ }
    { organization }
  if$
}


%% Output: assembling the pieces of a reference ---------------------------
%  Each piece is preceded by a separator. An empty piece is skipped together
%  with its separator: no orphan punctuation.

FUNCTION {emit}
{ duplicate$ empty$
    { pop$ }
    { 's :=
      space.next
        { " " 'next.sep :=
          #0 'space.next :=
        }
        'skip$
      if$
      started
        { next.sep ". " =
            { add.period$ " " * }
            { next.sep * }
          if$
          write$
        }
        { #1 'started := }
      if$
      s
      #0 'last.url :=
    }
  if$
}

% The separator only changes if the piece is not empty: a missing piece
% (e.g. no edition) must not replace the period already planned.
FUNCTION {out.period} { duplicate$ empty$ { pop$ } { ". " 'next.sep := emit } if$ }
FUNCTION {out.comma}  { duplicate$ empty$ { pop$ } { ", " 'next.sep := emit } if$ }
FUNCTION {out.space}  { duplicate$ empty$ { pop$ } { " " 'next.sep := emit } if$ }
FUNCTION {out.none}   { "" 'next.sep := emit }

FUNCTION {out.url}
{ duplicate$ empty$
    { pop$ }
    { out.period #1 'last.url := }
  if$
}

% Final period, except after a URL or DOI (Springer convention).
FUNCTION {fin.entry}
{ started
    { last.url
        'write$
        { add.period$ write$ }
      if$
      newline$
    }
    'skip$
  if$
}


%% Names ------------------------------------------------------------------------

% One name in CMP format: "Lenat JF", "van der Berg J", "Jones M Jr".
FUNCTION {format.bib.name}
{ s nameptr "{vv~}{ll}" format.name$
  s nameptr "{f{}}" format.name$ "-" "" replace.substring
  duplicate$ empty$ { pop$ } { " " swap$ * * } if$
  s nameptr "{jj}" format.name$
  duplicate$ empty$ { pop$ } { " " swap$ * * } if$
}

% Author list of the reference list: "Silver L, Stolper E".
FUNCTION {format.bib.names}
{ 's :=
  s num.names$ 'numnames :=
  cfg.max.names #0 > numnames cfg.max.names > and
    { cfg.max.names 'maxn := }
    { numnames 'maxn := }
  if$
  #1 'nameptr :=
  ""
    { nameptr maxn > not }
    { s nameptr "{ff }{vv }{ll}{ jj}" format.name$ "l" change.case$ "others" =
        { " \bibetal{}" *
          maxn #1 + 'nameptr :=
        }
        { nameptr #1 > { ", " * } 'skip$ if$
          format.bib.name *
          nameptr #1 + 'nameptr :=
        }
      if$
    }
  while$
  maxn numnames <
    { " \bibetal{}" * }
    'skip$
  if$
}

FUNCTION {format.editors}
{ editor empty$
    { "" }
    { editor format.bib.names
      editor num.names$ #1 >
        { " \bibeds{}" * }
        { " \bibed{}" * }
      if$
    }
  if$
}

% Short citation label: "Silver and Stolper", "Foucault et al.".
FUNCTION {format.lab.names}
{ 's :=
  s num.names$ 'numnames :=
  s #1 "{vv~}{ll}" format.name$
  numnames #1 >
    { numnames #2 =
        { s #2 "{ff }{vv }{ll}{ jj}" format.name$ "l" change.case$ "others" =
            { " \bibetal{}" * }
            { " \biband{} " * s #2 "{vv~}{ll}" format.name$ * }
          if$
        }
        { " \bibetal{}" * }
      if$
    }
    'skip$
  if$
}

% Long citation label (\citet*): all names.
FUNCTION {format.long.names}
{ 's :=
  s num.names$ 'numnames :=
  numnames 'namesleft :=
  #1 'nameptr :=
  ""
    { namesleft #0 > }
    { s nameptr "{vv~}{ll}" format.name$ 't :=
      nameptr #1 >
        { namesleft #1 >
            { ", " * t * }
            { t "l" change.case$ "others" =
                { " \bibetal{}" * }
                { " \biband{} " * t * }
              if$
            }
          if$
        }
        { t * }
      if$
      nameptr #1 + 'nameptr :=
      namesleft #1 - 'namesleft :=
    }
  while$
}


%% Source of the citation label --------------------------------------------------------
%  1 authors, 2 editors (edited volumes), 3 organisation, 4 key, 5 title.

FUNCTION {is.container.type}
{ type$ "incollection" =
  type$ "inproceedings" = or
  type$ "conference" = or
  type$ "inbook" = or
  type$ "inreference" = or
}

FUNCTION {set.name.source}
{ author empty$ not
    { #1 }
    { editor empty$ not is.container.type not and
        { #2 }
        { organization empty$ not
            { #3 }
            { key empty$ not
                { #4 }
                { #5 }
              if$
            }
          if$
        }
      if$
    }
  if$
  'name.source :=
}

FUNCTION {make.short.label}
{ name.source #1 =
    { author format.lab.names }
    { name.source #2 =
        { editor format.lab.names }
        { name.source #3 =
            { organization }
            { name.source #4 =
                { key }
                { title field.or.null #80 text.prefix$ }
              if$
            }
          if$
        }
      if$
    }
  if$
}

FUNCTION {make.long.label}
{ name.source #1 =
    { author format.long.names }
    { name.source #2 =
        { editor format.long.names }
        { label.short }
      if$
    }
  if$
}

FUNCTION {set.year}
{ year empty$
    { date empty$
        { "\bibnodate{}" }
        { date #1 #4 substring$ }
      if$
    }
    { year }
  if$
  'the.year :=
}


%% Reusable pieces ----------------------------------------------------------

FUNCTION {is.online.type}
{ type$ "online" =
  type$ "website" = or
  type$ "webpage" = or
  type$ "www" = or
  type$ "electronic" = or
}

FUNCTION {title.piece}
{ title empty$
    { "" "empty title in " cite$ * warning$ }
    { title
      is.online.type
        { " \bibonline{}" * }
        'skip$
      if$
    }
  if$
}

% Names and year: "Silver L, Stolper E (1989)".
FUNCTION {out.names.year}
{ name.source #1 =
    { author format.bib.names out.period }
    { name.source #2 =
        { format.editors out.period }
        { name.source #3 =
            { organization out.period }
            { title.piece out.period }
          if$
        }
      if$
    }
  if$
  "(" list.year * ")" * out.space
  #1 'space.next :=
}

FUNCTION {out.title}
{ name.source #4 <
    { title.piece out.period }
    'skip$
  if$
}

% Edition: "3rd edn"; the first edition is not printed.
FUNCTION {edition.piece}
{ edition empty$
    { "" }
    { edition "1" =
        { "" }
        { edition is.digits
            { "\bibedition{" edition * "}." * }
            { edition }
          if$
        }
      if$
    }
  if$
}

% Series and volume: "Lecture Notes in Earth Sciences, vol 12".
FUNCTION {series.volume.piece}
{ volume empty$
    { number empty$ type$ "book" = not or
        { "" }
        { "\bibvol{}~" number * }
      if$
    }
    { "\bibvol{}~" volume * }
  if$
  series empty$
    'skip$
    { duplicate$ empty$
        { pop$ series }
        { series ", " * swap$ * }
      if$
    }
  if$
}

FUNCTION {publisher.address.piece}
{ publisher empty$
    { get.address }
    { get.address empty$
        { publisher }
        { publisher ", " * get.address * }
      if$
    }
  if$
}

% Pages of a part: "pp 217--239" or "p 116".
FUNCTION {part.pages.piece}
{ get.pages empty$
    { "" }
    { get.pages multi.page.check
        { "\bibpp{" get.pages n.dashify * "}" * }
        { "\bibp{" get.pages * "}" * }
      if$
    }
  if$
}

% Total number of pages: "307 pp".
FUNCTION {total.pages.piece}
{ pagetotal empty$
    { pages empty$
        { "" }
        { pages multi.page.check
            { "" }
            { pages }
          if$
        }
      if$
    }
    { pagetotal }
  if$
  duplicate$ is.digits
    { "\bibtotalpages{" swap$ * "}" * }
    'skip$
  if$
}

FUNCTION {out.isbn}
{ cfg.show.isbn isbn empty$ not and
    { "ISBN " isbn * out.period }
    'skip$
  if$
}

FUNCTION {out.note}
{ note out.period }

% DOI: strips the prefixes https://doi.org/, doi: ...
FUNCTION {clean.doi}
{ doi 't :=
  t "l" change.case$ 's :=
  s #1 #16 substring$ "https://doi.org/" =
    { t #17 global.max$ substring$ 't := }
    { s #1 #15 substring$ "http://doi.org/" =
        { t #16 global.max$ substring$ 't := }
        { s #1 #19 substring$ "https://dx.doi.org/" =
            { t #20 global.max$ substring$ 't := }
            { s #1 #18 substring$ "http://dx.doi.org/" =
                { t #19 global.max$ substring$ 't := }
                { s #1 #4 substring$ "doi:" =
                    { t #5 global.max$ substring$ 't := }
                    'skip$
                  if$
                }
              if$
            }
          if$
        }
      if$
    }
  if$
  t
}

% Access date: ISO (2025-11-14) -> \bibdate{2025}{11}{14}.
FUNCTION {format.urldate}
{ get.urldate 't :=
  t text.length$ #10 =
  t #5 #1 substring$ "-" = and
  t #8 #1 substring$ "-" = and
    { "\bibdate{" t #1 #4 substring$ * "}{" *
      t #6 #2 substring$ * "}{" * t #9 #2 substring$ * "}" * }
    { t text.length$ #7 =
      t #5 #1 substring$ "-" = and
        { "\bibdate{" t #1 #4 substring$ * "}{" *
          t #6 #2 substring$ * "}{}" * }
        { t }
      if$
    }
  if$
}

% DOI or URL, then access date.
FUNCTION {out.doi.url}
{ #0 'multiresult :=
  doi empty$
    'skip$
    { "\url{https://doi.org/" clean.doi * "}" * out.url
      #1 'multiresult :=
    }
  if$
  url empty$ not
  doi empty$ cfg.url.with.doi or and
    { "\url{" url * "}" * out.url
      #1 'multiresult :=
    }
    'skip$
  if$
  multiresult get.urldate empty$ not and
    { "\bibaccessed{" format.urldate * "}" * out.none }
    'skip$
  if$
}

FUNCTION {output.bibitem}
{ newline$
  "\bibitem[{" write$
  label.short write$
  "(" write$
  list.year write$
  ")" write$
  make.long.label write$
  "}]{" write$
  cite$ write$
  "}" write$
  newline$
  #0 'started :=
  #0 'last.url :=
  #0 'space.next :=
  ". " 'next.sep :=
}


%% Entry types --------------------------------------------------------------

% Silver L, Stolper E (1989) Title. J Petrol 30:667–709. https://doi.org/...
FUNCTION {journal.piece}
{ get.journal 't :=
  volume empty$
    { "" }
    { cfg.show.issue number empty$ not and
        { volume "(" * number * ")" * }
        { volume }
      if$
    }
  if$
  's :=
  t
  s empty$
    'skip$
    { duplicate$ empty$ { pop$ s } { " " * s * } if$ }
  if$
  get.pages empty$
    'skip$
    { s empty$
        { duplicate$ empty$ 'skip$ { ", " * } if$ }
        { ":" * }
      if$
      get.pages n.dashify *
    }
  if$
}

FUNCTION {article}
{ output.bibitem
  out.names.year
  out.title
  journal.piece out.period
  out.note
  out.doi.url
  fin.entry
}

% Cojan I, Renard M (2021) Sedimentology. 3rd edn. Dunod, Paris
FUNCTION {book}
{ output.bibitem
  out.names.year
  out.title
  edition.piece out.period
  series.volume.piece out.period
  publisher.address.piece out.period
  total.pages.piece out.comma
  out.isbn
  out.note
  out.doi.url
  fin.entry
}

% Springer (CMP) convention for a chapter in an edited book:
%   Title. In: Editors (eds) Book title, 2nd edn. Series. Publisher, City, pp 121--141
% The editors precede the book title, without a comma; "(eds)" follows the
% names directly (see \bibed in the preamble).
FUNCTION {out.in.container}
{ editor empty$ not
    { "\bibin{} " format.editors * " " * booktitle * }
    { booktitle empty$
        { "" }
        { "\bibin{} " booktitle * }
      if$
    }
  if$
  out.period
  edition.piece out.period
  type$ "inproceedings" = type$ "conference" = or
    { get.eventdate out.period
      venue out.comma
    }
    'skip$
  if$
  series.volume.piece out.period
  publisher.address.piece out.period
  publisher.address.piece empty$
    { part.pages.piece out.period }
    { part.pages.piece out.comma }
  if$
}

FUNCTION {incollection}
{ output.bibitem
  out.names.year
  out.title
  out.in.container
  out.isbn
  out.note
  out.doi.url
  fin.entry
}

FUNCTION {inproceedings} { incollection }
FUNCTION {conference} { incollection }
FUNCTION {inreference} { incollection }

% @inbook: with booktitle, treated like a chapter; without, a part of a book.
FUNCTION {inbook}
{ booktitle empty$
    { output.bibitem
      out.names.year
      out.title
      edition.piece out.period
      chapter empty$ { "" } { "\bibchap{}~" chapter * } if$ out.period
      series.volume.piece out.period
      publisher.address.piece out.period
      part.pages.piece out.comma
      out.isbn
      out.note
      out.doi.url
      fin.entry
    }
    { incollection }
  if$
}

% IAH (2024) IAH World Groundwater Congress, 8-13 September, Davos, Switzerland
FUNCTION {proceedings}
{ output.bibitem
  out.names.year
  out.title
  get.eventdate out.comma
  venue out.comma
  name.source #2 =
    'skip$
    { format.editors out.period }
  if$
  series.volume.piece out.period
  publisher.address.piece out.period
  out.isbn
  out.note
  out.doi.url
  fin.entry
}

% Torrent G (1974) Title. Dissertation. Example University, Example City
FUNCTION {thesis.body}
{ out.names.year
  out.title
  tag out.period
  get.school out.period
  get.address out.comma
  total.pages.piece out.comma
  out.note
  out.doi.url
  fin.entry
}

FUNCTION {phdthesis}
{ output.bibitem
  type empty$ { "\bibphdthesis{}" } { type } if$ 'tag :=
  thesis.body
}

FUNCTION {mastersthesis}
{ output.bibitem
  type empty$ { "\bibmastersthesis{}" } { type } if$ 'tag :=
  thesis.body
}

FUNCTION {thesis}
{ output.bibitem
  type empty$ { "\bibthesis{}" } { type } if$ 'tag :=
  thesis.body
}

% Author (year) Title. Report BRGM/RP-12345-FR. BRGM, Orleans, 120 pp
FUNCTION {techreport}
{ output.bibitem
  out.names.year
  out.title
  type empty$
    { number empty$ { "" } { "\bibtechreport{} " number * } if$ }
    { number empty$ { type } { type " " * number * } if$ }
  if$
  out.period
  name.source #3 = organization field.or.null get.institution = and
    { "" }
    { get.institution }
  if$
  out.period
  get.address out.comma
  total.pages.piece out.comma
  out.note
  out.doi.url
  fin.entry
}

FUNCTION {report} { techreport }

FUNCTION {manual}
{ output.bibitem
  out.names.year
  out.title
  edition.piece out.period
  version empty$ { "" } { "\bibversion{} " version * } if$ out.comma
  name.source #3 = { "" } { organization field.or.null } if$ out.period
  publisher.address.piece out.comma
  total.pages.piece out.comma
  out.note
  out.doi.url
  fin.entry
}

FUNCTION {booklet}
{ output.bibitem
  out.names.year
  out.title
  howpublished out.period
  get.address out.comma
  total.pages.piece out.comma
  out.note
  out.doi.url
  fin.entry
}

% Web site and miscellaneous documents.
FUNCTION {misc}
{ output.bibitem
  out.names.year
  out.title
  howpublished empty$
    'skip$
    { howpublished #1 #4 substring$ "\url" =
        { howpublished out.url }
        { howpublished out.period }
      if$
    }
  if$
  get.site out.period
  publisher.address.piece out.period
  out.note
  out.doi.url
  fin.entry
}

FUNCTION {online} { misc }
FUNCTION {website} { misc }
FUNCTION {webpage} { misc }
FUNCTION {www} { misc }
FUNCTION {electronic} { misc }

% Global Volcanism Program (2013) Volcanoes of the World (version 4.3)
% [dataset]. Smithsonian Institution. https://doi.org/...
FUNCTION {data.body}
{ out.names.year
  name.source #4 <
    { title field.or.null
      version empty$ 'skip$ { " (\bibversion{} " * version * ")" * } if$
      " " * tag *
      out.period
    }
    { tag out.space }
  if$
  publisher empty$ { get.site } { publisher } if$ out.period
  howpublished out.period
  out.note
  out.doi.url
  fin.entry
}

FUNCTION {dataset}
{ output.bibitem
  "\bibdataset{}" 'tag :=
  data.body
}

FUNCTION {software}
{ output.bibitem
  "\bibsoftware{}" 'tag :=
  data.body
}

% ISO (2018) Title of the standard. NF EN ISO 19650. 36 pp
FUNCTION {standard}
{ output.bibitem
  out.names.year
  out.title
  type empty$
    { number field.or.null }
    { number empty$ { type } { type " " * number * } if$ }
  if$
  out.period
  name.source #3 = { "" } { publisher.address.piece } if$ out.period
  total.pages.piece out.period
  out.note
  out.doi.url
  fin.entry
}

% Prefect of Yvelines (2018) Decree of 25 May 2018... Decree no. 2018145-0001
FUNCTION {legislation}
{ output.bibitem
  out.names.year
  out.title
  number empty$
    { type field.or.null }
    { type empty$
        { "\bibno{" number * "}" * }
        { type " \bibno{" * number * "}" * }
      if$
    }
  if$
  out.period
  out.note
  out.doi.url
  fin.entry
}

FUNCTION {law} { legislation }
FUNCTION {jurisdiction} { legislation }

% Dufour J, BRGM (1978) Autun (Geological Map of France, sheet 551).
% 1:50 000. BRGM, Orleans
FUNCTION {map}
{ output.bibitem
  out.names.year
  name.source #4 <
    { title.piece
      series empty$
        { number empty$
            'skip$
            { " (\bibsheet{}~" * number * ")" * }
          if$
        }
        { " (" * series *
          number empty$ 'skip$ { ", \bibsheet{}~" * number * } if$
          ")" *
        }
      if$
      out.period
    }
    'skip$
  if$
  scale out.period
  publisher.address.piece out.period
  out.note
  out.doi.url
  fin.entry
}

FUNCTION {patent}
{ output.bibitem
  out.names.year
  out.title
  type empty$ { "\bibpatent{}" } { type } if$
  number empty$ 'skip$ { " " * number * } if$
  out.period
  out.note
  out.doi.url
  fin.entry
}

FUNCTION {unpublished}
{ output.bibitem
  out.names.year
  out.title
  howpublished out.period
  out.note
  out.doi.url
  fin.entry
}

FUNCTION {collection} { book }
FUNCTION {mvbook} { book }
FUNCTION {mvcollection} { book }
FUNCTION {reference} { book }
FUNCTION {periodical} { book }
FUNCTION {mvproceedings} { proceedings }
FUNCTION {default.type} { misc }


%% Month abbreviations --------------------------------------------------------

MACRO {jan} {"January"}
MACRO {feb} {"February"}
MACRO {mar} {"mars"}
MACRO {apr} {"April"}
MACRO {may} {"mai"}
MACRO {jun} {"juin"}
MACRO {jul} {"juillet"}
MACRO {aug} {"August"}
MACRO {sep} {"September"}
MACRO {oct} {"octobre"}
MACRO {nov} {"novembre"}
MACRO {dec} {"December"}


%% Reading and sorting --------------------------------------------------------------

READ

% UTF-8 accents reduced to the base letter for sorting (Lenat before Lenoir).
FUNCTION {fold.accents}
{ "é" "e" replace.substring  "è" "e" replace.substring
  "ê" "e" replace.substring  "ë" "e" replace.substring
  "à" "a" replace.substring  "â" "a" replace.substring
  "ä" "a" replace.substring  "á" "a" replace.substring
  "î" "i" replace.substring  "ï" "i" replace.substring
  "í" "i" replace.substring  "ô" "o" replace.substring
  "ö" "o" replace.substring  "ó" "o" replace.substring
  "ø" "o" replace.substring  "ù" "u" replace.substring
  "û" "u" replace.substring  "ü" "u" replace.substring
  "ú" "u" replace.substring  "ç" "c" replace.substring
  "ñ" "n" replace.substring  "å" "a" replace.substring
  "É" "E" replace.substring  "È" "E" replace.substring
  "À" "A" replace.substring  "Ç" "C" replace.substring
  "Ö" "O" replace.substring  "Ü" "U" replace.substring
}

FUNCTION {sortify}
{ fold.accents
  purify$
  "l" change.case$
}

FUNCTION {sort.format.title}
{ 't :=
  "A " #2
    "An " #3
      "The " #4
        "Le " #3
          "La " #3
            "Les " #4 t chop.word
          chop.word
        chop.word
      chop.word
    chop.word
  chop.word
  sortify
  #1 global.max$ substring$
}

FUNCTION {sort.name}
{ #1 "{ll{ }}{  vv{ }}{  ff{ }}{  jj{ }}" format.name$ sortify }

% Sort key: first author, group (1, 2 + second author, 3), year, title.
FUNCTION {names.sort.key}
{ 's :=
  s num.names$ 'numnames :=
  s sort.name
  numnames #1 =
    { "    1" * }
    { numnames #2 =
        { "    2    " * s #2 "{ll{ }}{  vv{ }}{  ff{ }}{  jj{ }}" format.name$
          sortify * }
        { "    3" * }
      if$
    }
  if$
}

FUNCTION {presort}
{ set.name.source
  set.year
  make.short.label 'label.short :=
  label.short " " * the.year * purify$ 'sort.label :=
  name.source #1 =
    { author names.sort.key }
    { name.source #2 =
        { editor names.sort.key }
        { name.source #3 =
            { organization sortify "    1" * }
            { name.source #4 =
                { key sortify "    1" * }
                { title field.or.null sort.format.title "    1" * }
              if$
            }
          if$
        }
      if$
    }
  if$
  "    " *
  year empty$ date empty$ and
    { "9999" }
    { the.year sortify }
  if$
  *
  "    " *
  title field.or.null sort.format.title *
  #1 entry.max$ substring$
  'sort.key$ :=
}

ITERATE {presort}

SORT


%% Disambiguation letters (2020a, 2020b) ----------------------------------

FUNCTION {initialize.extra.label.stuff}
{ #0 int.to.chr$ 'last.label :=
  "" 'next.extra :=
  #0 'last.extra.num :=
}

FUNCTION {forward.pass}
{ last.label sort.label =
    { last.extra.num #1 + 'last.extra.num :=
      last.extra.num int.to.chr$ 'extra.label :=
    }
    { "a" chr.to.int$ 'last.extra.num :=
      "" 'extra.label :=
      sort.label 'last.label :=
    }
  if$
}

FUNCTION {reverse.pass}
{ next.extra "b" =
    { "a" 'extra.label := }
    'skip$
  if$
  extra.label 'next.extra :=
  extra.label empty$
    { the.year }
    { the.year "{\natexlab{" * extra.label * "}}" * }
  if$
  'list.year :=
}

EXECUTE {initialize.extra.label.stuff}
ITERATE {forward.pass}
REVERSE {reverse.pass}


%% Writing the .bbl ------------------------------------------------------------
%  Words written by the style, English by default. For another language,
%  redefine the macros in the preamble with \newcommand (before
%  \bibliography): \providecommand does not overwrite them.

FUNCTION {begin.bib}
{ preamble$ empty$
    'skip$
    { preamble$ write$ newline$ }
  if$
  "\providecommand{\natexlab}[1]{#1}" write$ newline$
  "\providecommand{\url}[1]{\texttt{#1}}" write$ newline$
  "\providecommand{\biband}{and}" write$ newline$
  "\providecommand{\bibetal}{et~al.}" write$ newline$
  "\providecommand{\bibin}{In:}" write$ newline$
  "\providecommand{\bibed}{(ed)}" write$ newline$
  "\providecommand{\bibeds}{(eds)}" write$ newline$
  "\providecommand{\bibedition}[1]{#1\ifcase#1\or st\or nd\or rd\else th\fi~edn}" write$ newline$
  "\providecommand{\bibvol}{vol}" write$ newline$
  "\providecommand{\bibchap}{chap}" write$ newline$
  "\providecommand{\bibpp}[1]{pp~#1}" write$ newline$
  "\providecommand{\bibp}[1]{p~#1}" write$ newline$
  "\providecommand{\bibtotalpages}[1]{#1~pp}" write$ newline$
  "\providecommand{\bibonline}{[online]}" write$ newline$
  "\providecommand{\bibaccessed}[1]{. Accessed #1}" write$ newline$
  "\providecommand{\bibdate}[3]{\ifx\relax#3\relax\else\number#3\ \fi\ifcase#2\or January\or February\or March\or April\or May\or June\or July\or August\or September\or October\or November\or December\fi\ #1}" write$ newline$
  "\providecommand{\bibnodate}{n.d.}" write$ newline$
  "\providecommand{\bibphdthesis}{Dissertation}" write$ newline$
  "\providecommand{\bibmastersthesis}{Master's thesis}" write$ newline$
  "\providecommand{\bibthesis}{Thesis}" write$ newline$
  "\providecommand{\bibtechreport}{Technical report}" write$ newline$
  "\providecommand{\bibpatent}{Patent}" write$ newline$
  "\providecommand{\bibsheet}{sheet}" write$ newline$
  "\providecommand{\bibno}[1]{no.~#1}" write$ newline$
  "\providecommand{\bibversion}{version}" write$ newline$
  "\providecommand{\bibdataset}{[dataset]}" write$ newline$
  "\providecommand{\bibsoftware}{[software]}" write$ newline$
  "\begin{thebibliography}{99}" write$ newline$
  "\csname NoAutoSpacing\endcsname" write$ newline$
}

EXECUTE {begin.bib}

ITERATE {call.type$}

FUNCTION {end.bib}
{ newline$
  "\end{thebibliography}" write$ newline$
}

EXECUTE {end.bib}
