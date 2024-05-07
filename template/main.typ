#import "@preview/chiral-thesis-fhe:0.1.0" as ctf
#import ctf.prelude: *

#show: doc(
  kind: bachelors-thesis(
    id: [AI-1970-MA-999],
    title: [Mustertitel],
    // subtitle: [],
    author: "Max Mustermann",
    date: datetime(year: 1970, month: 01, day: 01),
    field: [Angewandte Informatik],
  ),
  outlines: (
    // you can remove any of these if you don't need them
    (target: image, title: [Abbildungsverzeichnis]),
    (target: table, title: [Tabellenverzeichnis]),
    (target: raw,   title: [Listingverzeichnis]),
  ),
  outlines-position: start,
  bibliography: bibliography("/bibliography.yaml"),
)

// these are your main document chapters, you can reference them using @chap:...
#chapter[Einleitung] <chap:intro>
#include "chapters/1 - intro.typ"

#chapter[Grundlagen] <chap:basics>
#include "chapters/2 - basics.typ"

#chapter[Konzept] <chap:concept>
#include "chapters/3 - concept.typ"

#chapter[Implementierung] <chap:impl>
#include "chapters/4 - impl.typ"

#chapter[Fazit] <chap:conclusion>
#include "chapters/5 - conclusion.typ"
