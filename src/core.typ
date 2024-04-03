#import "packages.typ"
#import "authors.typ"
#import "kinds.typ"
#import "styles.typ"
#import "utils.typ"

// TODO: static positioning on the title page
// TODO: arg validation
// TODO: provide good defaults
#let doc(
  kind: kinds.report(),
  abstracts: none,
  bibliography: none,
  listings: (),
  listings-position: end,
  glossary: none,
  acronyms: none,
  appendices: none,
  acknowledgement: none,
  independence: auto,
) = body => {
  let meta = kind

  let title-page = {
    set align(center + top)
    stack(
      align(right, image("/assets/images/logo-fhe.svg", width: 45%)),
      5em,
      text(16pt, strong[
        #meta.kind.name \
        #meta.field
      ]),
      ..if kinds.is-thesis(meta.kind) { (1em, [Nr. #meta.id]) },
      5em,
      text(32pt, font: "Latin Modern Sans", strong(meta.title)),
      3.4em,
      // TODO: proper handling of more than one author
      text(16pt, strong(authors.format-author(meta.author, email: false))),
      2.5em,
      text(18pt)[Abgabedatum: #utils.format-date(meta.date)],
    )

    if kinds.is-thesis(meta.kind) {
      place(center + bottom, text(18pt, meta.supervisors.join(linebreak())))
    }

    pagebreak(weak: true)
  }

  let abstract-pages = if abstracts != none {
    set align(horizon)
    for abstract in abstracts {
      block(width: 100%, strong(text(22pt, abstract.title)))
      par(justify: true, abstract.abstract)
      pagebreak(weak: true)
    }
  }

  let outline-page = {
    show outline.entry: it => {
      // do not indent appendices
      if it.level == 1 or it.element.numbering == utils.number-appendices {
        v(18pt, weak: true)
        strong({
          link(it.element.location(), text(font: "Latin Modern Sans", it.body))
          h(1fr)
          it.page
        })
      } else {
        link(it.element.location(), it.body)
        [ ]
        box(width: 1fr, repeat("  .  "))
        [ ]
        box(
          width: measure[999].width,
          align(right, it.page),
        )
      }
    }

    // NOTE: turn off heading styles here
    show outline: set heading(outlined: false)
    outline(depth: 3, indent: auto)
    pagebreak(weak: true)
  }

  let body = {
    show: styles.content()

    body
  }

  let bibliography-page = bibliography

  // TODO: pull in packages for those are allow this to be agnostic
  let glossary-page = if glossary != none {
    // 1. glossary/acronyms impl
    show terms: it => {
      for item in it.children {
        let term-label = label("gls:" + item.term.text.replace(" ", "-"))
        let term = [#item.term]
        [*#term:* #item.description #metadata((term: term, descr: item.description)) #term-label\ ]
      }
    }

    heading(level: 1)[Glossar]
    glossary
  }

  let acronyms-page = if acronyms != none {
    // 1. glossary/acronyms impl
    show terms: it => {
      for item in it.children {
        let term-label = label("acr:" + item.term.text.replace(" ", "-"))
        let term = [#item.term]
        [*#term:* #item.description #metadata((term: term, descr: item.description)) #term-label\ ]
      }
    }

    heading(level: 1)[Abkürzungen]
    acronyms
  }

  let listings-pages = {
    listings.map(listing => {
      outline(target: figure.where(kind: listing.target), title: listing.title)
    })
    .join(pagebreak(weak: true))
  }

  let appendices-page = if appendices != none {
    set heading(numbering: utils.number-appendices, supplement: [Anhang])

    heading(level: 1)[Anhang]
    (appendices,).flatten().join(pagebreak(weak: true))
  }

  let acknowledgement-page = if acknowledgement != none {
    heading(level: 1)[Danksagung]
    acknowledgement
  }

  let independence-page = if independence == auto {
    heading(level: 1)[Eigenständigkeitserklärung]
    [
      Ich, #authors.format-author(meta.author, email: false), versichere hiermit, dass ich die vorliegende #meta.kind.name mit dem Thema
      #align(center, emph(meta.title))
      selbstständig und nur unter Verwendung der angegebenen Quellen und Hilfsmittel angefertigt habe.
    ]
  
    align(right)[
      Erfurt, #utils.format-date(meta.date)
    ]
    authors.format-author(meta.author, email: false)
  } else if type(independence) == content {
    heading(level: 1)[Eigenständigkeitserklärung]
    independence
  }

  // 2. glossary/acronyms impl
  show ref: it => {
    let target = str(it.target)
    if target.starts-with(regex("(gls|acr):")) {
      let marker = label(target + ":used")
      let back-ref = link(it.target, if it.citation.supplement != none {
          it.citation.supplement
        } else {
          locate(loc => query(it.target, loc).last().value.term)
        })
      let opt-footnote = locate(loc => {
        let markers = query(selector(marker).before(loc), loc)
        if markers.len() == 1 {
          footnote(query(it.target, loc).last().value.descr)
        }
      })
      [#back-ref#marker#opt-footnote]
    } else {
      it
    }
  }

  show: styles.global()

  title-page
  abstract-pages

  set page(
    "a4",
    header: {
      [Fachhochschule Erfurt]
      h(1fr)
      meta.field
      v(-0.5em)
      line(length: 100%)
      counter(footnote).update(0)
    },
    footer: context {
      set align(right)
      set align(left) if calc.even(here().page())

      if page.numbering != none {
        counter(page).display(page.numbering)
      }
    },
  )

  // TODO: make configurable
  show: styles.heading()
  show: styles.table()
  show: styles.raw(theme: "/assets/themes/gruvbox-light.tmTheme", fill: rgb("#f9f5d7"))
  show: styles.figure(kinds: listings.map(l => l.target))
  show: styles.math()
  show: styles.bibliography()

  // start with roman numbering after the prelude
  set page(numbering: "I")
  counter(page).update(1)

  outline-page
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
  context counter(page).update(counter(page).at(locate(<__ctf_marker>)).first() + 1)

  bibliography-page
  glossary-page
  acronyms-page
  if listings-position == end {
    listings-pages
  }
  appendices-page

  if kinds.is-thesis(meta.kind) {
    acknowledgement-page
  }

  if kinds.is-thesis(meta.kind) {
    independence-page
  }
}
