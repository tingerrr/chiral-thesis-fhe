#import "packages.typ": *
#import ctf.prelude: *

// document-wide styles go here, before the template
// these will encompas your front and back matter too

// This is how the template is applied, the `doc` function takes in all
// remaining content and does the following with it:
// - Applie a number of styles to it, like heading and numbering styles
// - Add front and back matter according to the arguments
// - Add only those items deemed appropriate for the given kind
#show: doc(
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

// content wide styles go here, before the content
// these will apply to your front or back matter

// anything that is in this file such as includes will be styled by our template
// and be considered regular content

#chapter(label: <chap:intro>)[Intro]
#include "chapters/1 - intro.typ"

#chapter(label: <chap:basics>)[Basics]
#include "chapters/2 - basics.typ"

#chapter(label: <chap:printing>)[Printing]
#include "chapters/3 - printing.typ"

#chapter(label: <chap:conclusion>)[Conclusion]
#include "chapters/4 - conclusion.typ"
