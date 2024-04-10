#import "core/authors.typ"
#import "core/kinds.typ"
#import "core/structure.typ"
#import "core/styles.typ"

#import "/src/utils.typ" as _utils

// TODO: static positioning on the title page
// TODO: arg validation
// TODO: provide good defaults
#let doc(
  // kind: kinds.report(),
  kind: (:),
  abstracts: none,
  bibliography: none,
  listings: (),
  listings-position: end,
  listings-force-empty: false,
  appendices: none,
  acknowledgement: none,
  affidavit: auto,
) = body => {
  let meta = kind

  let body = {
    show: styles.content()

    body
  }

  // TODO: move rest to structure module

  let listings-pages = if listings != none and listings != () {
    listings.map(listing => {
      structure.make-listing(
        target: listing.target,
        title: listing.title,
        force-empty: listings-force-empty,
      )
    }).join(pagebreak(weak: true))
  }

  let appendices-page = if appendices != none {
    set heading(numbering: _utils.number-appendices, supplement: [Anhang])

    heading(level: 1)[Anhang]
    (appendices,).flatten().join(pagebreak(weak: true))
  }

  let bibliography-pages = if bibliography != none {
    bibliography
  }

  let acknowledgement-page = if acknowledgement != none {
    heading(level: 1)[Danksagung]
    acknowledgement
  }

  let affidavit-page = structure.make-affidavit(
    title: meta.title,
    author: meta.author,
    date: meta.date,
    body: affidavit,
    kind: meta.kind,
  )

  show: styles.global()

  structure.make-title-page(..meta)

  if abstracts != none {
    abstracts.map(abstract => {
      structure.make-abstract(..abstract)
    }).join(pagebreak(weak: true))
  }

  set page(
    header: {
      set text(8pt, font: "Latin Modern Sans")
      [Fachhochschule Erfurt]
      h(1fr)
      meta.field
      v(-0.5em)
      line(length: 100%, stroke: 0.5pt)
      counter(footnote).update(0)
    },
    footer: context {
      set align(if calc.even(here().page()) { left } else { right })

      if page.numbering != none {
        counter(page).display(page.numbering)
      }
    },
  )

  // TODO: make configurable
  show: styles.table()
  show: styles.raw(theme: "/assets/themes/gruvbox-light.tmTheme", fill: rgb("#f9f5d7"))
  show: styles.math()
  show: styles.figure(kinds: listings.map(l => l.target))
  show: styles.bibliography()

  // NOTE: this must currently stay below the figure syles to ensure the fully realized level 1 headings start with their weak pagebreak.
  show: styles.heading()

  // start with roman numbering after the prelude
  set page(numbering: "I")
  counter(page).update(1)

  structure.make-table-of-contents()

  if listings-position == start {
    listings-pages
  }

  // an anchor to retreive the page number we left off with for later
  [#metadata(()) <__ctf_marker>]

  // use arabic numbering
  set page(numbering: "1")
  counter(page).update(1)
  body

  // revert back to roman numbring, continuing where we left off
  set page(numbering: "I")
  context counter(page).update(counter(page).at(<__ctf_marker>).first() + 1)

  bibliography-pages

  if listings-position == end {
    listings-pages
  }
  appendices-page

  if kinds.is-thesis(meta.kind) {
    acknowledgement-page
  }

  if kinds.is-thesis(meta.kind) {
    affidavit-page
  }
}
