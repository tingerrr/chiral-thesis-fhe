#import "@preview/chiral-thesis-fhe:0.1.0": template, bachelors-thesis, util
#import util: chapter

#show: template(
  kind: bachelors-thesis(
    id: [AI-#datetime.today().year();-MA-999],
    title: [Mustertitel],
    // subtitle:
    author: [Max Mustermann],
    place: [Erfurt],
    date: datetime.today(),
    spec: [Angewandte Informatik],
    spec-in: [Angewandten Informatik],
  ),
  listings: (
    // you can remove any of these if you don't need them
    (target: image, title: [Abbildungsverzeichnis]),
    (target: table, title: [Tabellenverzeichnis]),
    (target: raw,   title: [Listingverzeichnis]),
  ),
  listing-position: start,
  glossary: "/appendices/glossary.typ",
  acronyms: "/appendices/acronyms.typ",
  bib: "/bibliography.yaml",
)

#show cite: text.with(fill: purple)
#show link: text.with(fill: blue)

// these are your main document chapters, you can reference them using @chap:...
#chapter[Intro] <chap:intro>
#include "chapters/1 - intro.typ"

#chapter[Basics] <chap:basics>
#include "chapters/2 - basics.typ"

#chapter[Concept] <chap:concept>
#include "chapters/3 - concept.typ"

#chapter[Implementation] <chap:impl>
#include "chapters/4 - impl.typ"

#chapter[Conculsion] <chap:conclusion>
#include "chapters/5 - conclusion.typ"
