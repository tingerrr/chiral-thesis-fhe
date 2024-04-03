#import "@preview/chiral-thesis-fhe:0.1.0" as ctf
#import ctf.prelude: *

#show: doc(
  kind: bachelors-thesis(
    id: [AI-1970-MA-999],
    title: [Mustertitel],
    // subtitle:
    author: "Max Mustermann",
    date: datetime.today(),
    field: [Angewandte Informatik],
  ),
  listings: (
    // you can remove any of these if you don't need them
    (target: image, title: [Abbildungsverzeichnis]),
    (target: table, title: [Tabellenverzeichnis]),
    (target: raw,   title: [Listingverzeichnis]),
  ),
  listings-position: start,
  glossary: import "/appendices/glossary.typ",
  acronyms: import "/appendices/acronyms.typ",
  bibliography: bibliography("/bibliography.yaml"),
)

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
