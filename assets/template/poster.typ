#import "packages.typ": *
#import ctf.prelude: *

#show: poster(
  // this defines how the title page is rendered and which parts are included in
  // the document, crucially, when you don't provide an affidavit but use a
  // thesis kind, then a default one is generated for you
  //
  // reports will ignore affidavits and acknowledgements
  doc: bachelors-thesis(
    id: [AI-1970-MA-999],
    title: [Mustertitel],
    author: "Max Mustermann",
    date: datetime(year: 1970, month: 01, day: 01),
    faculty: [Angewandte Informatik],
  ),

  image: none,
  cv: par(justify: true, lorem(75)),
  theme: _theme.themes.applied-computer-science,

  // here are our outlines, they list figures of different kinds
  outlines: (
    // you can remove any of these if you don't need them
    (target: image, title: [Abbildungsverzeichnis]),
    (target: table, title: [Tabellenverzeichnis]),
    (target: raw,   title: [Listingverzeichnis]),
  ),
  // by default they're at the start (i.e. in the front matter), you can use
  // `end` here to put them in the back matter
  outlines-position: start,

  // we can include some appendices by referencing them here
  appendices: (
    include "appendices/1-example.typ",
    [
      Antoher appendix, but this one is defined inline, not as a standalone file.
      If they get complicated including sub files is probably more sensible.
    ]
  ),

  // check out the bibliography file for more info
  bibliography: bibliography("bibliography.yaml"),
)
