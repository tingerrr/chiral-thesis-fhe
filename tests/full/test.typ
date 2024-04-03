#import "/src/lib.typ" as ctf
#import ctf.prelude: *

#show: doc(
  kind: masters-thesis(
    date: datetime(year: 1970, month: 01, day: 01),
  ),
  abstracts: (
    (title: [Abstract], abstract: lorem(100)),
  ),
  listings: (
    (target: image, title: [Abbildungsverzeichnis]),
    (target: table, title: [Tabellenverzeichnis]),
    (target: raw, title: [Listingverzeichnis]),
  ),
  listings-position: start,
  bibliography: bibliography("/tests/bib.yaml"),
  glossary: [
    / computer science: A science concerned with computation.
  ],
  acronyms: [
    / FHE: Fachhochschule Erfurt.
  ],
)

#chapter[Chapter 1]
#lorem(10) https://github.com/tingerrr/chiral-thesis-fhe

#figure(
  table(columns: 2,
    table.header[A][B],
    [Hello], [World]
  ),
  caption: [A table example],
)

#chapter[Chapter 2]
= Section
#lorem(10)
#figure(
  [Hello World],
  caption: [A figure example],
)

== Subsection
#lorem(10)

#figure(
  ```rust
  const CONST: &str = "Hello World";
  ```,
  caption: [A listing example],
)

#chapter[Chapter 3]
#lorem(10) #quote(attribution: <knuth>)[A quote example]

$
  E = m c^2
$
