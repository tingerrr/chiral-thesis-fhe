#import "packages.typ"
#import "utils.typ"

// TODO: static positioning on the title page
// TODO: arg validation
// TODO: provide good defaults

// TODO: make internal
#let is-kind-thesis(kind) = kind in ("thesis-bachelor", "thesis-master")

#let kind-to-name(kind) = if kind == "masters-thesis" {
  "Masterarbeit"
} else if kind == "bachelors-thesis" {
  "Bachelorarbeit"
} else {
  "Belegarbeit"
}

#let report(
    title: [Mustertitel],
    author: "Musterstudent, Max",
    field: [Fachbereich],
    date: datetime.today(),
) = {
  (
    kind: "report",

    title: title,
    author: author,
    field: field,

    date: date,
  )
}

#let thesis(
    kind: none,
    id: [ID],

    title: [Mustertitel],
    author: "Musterstudent, Max",
    field: [Fachbereich],
    date: datetime.today(),

    supervisors: (
      "Prof. Dr. Max Mustermann",
      "Prof. Dr. Maxine Musterfrau",
    ),
) = {
  (
    kind: kind,
    id: id,

    title: title,
    author: author,
    field: field,

    date: date,

    supervisors: supervisors,
  )
}

#let bachelors-thesis = thesis.with(kind: "thesis-bachelor")
#let masters-thesis = thesis.with(kind: "thesis-master")

#let doc(
  kind: report(title: [My Report]),
  abstracts: none,
  bib: none,
  listings: (),
  listing-position: bottom,
  glossary: none,
  acronyms: none,
  appendices: none,
  acknowledgement: none,
  independence: auto,
) = body => {
  let spec = packages.anti-matter.anti-thesis()
  let meta = kind
  set text(lang: "de", 11pt)

  let title-page = {
    set align(center + top)
    stack(
      align(right, image("/assets/images/logo-fhe.svg", width: 45%)),
      5em,
      text(16pt, strong[
        #kind-to-name(meta.kind) \
        #meta.field
      ]),
      ..if is-kind-thesis(meta.kind) { (1em, [Nr. #meta.id]) },
      5em,
      text(32pt, font: "Latin Modern Sans", strong(meta.title)),
      3.4em,
      // TODO: proper handling of more than one author and emails
      text(16pt, strong(meta.author)),
      2.5em,
      text(18pt)[Abgabedatum: #utils.format-date(meta.date)],
    )

    if is-kind-thesis(meta.kind) {
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
      if it.level == 1 or it.element.numbering == utils.number-appendices {
        v(18pt, weak: true)
        strong({
          link(it.element.location(), text(font: "Latin Modern Sans", it.body))
          h(1fr)
          packages.anti-matter.anti-page-at(spec, it.element.location())
        })
      } else {
        link(it.element.location(), it.body)
        [ ]
        box(width: 1fr, repeat("  .  "))
        [ ]
        packges.anti-matter.anti-page-at(spec, it.element.location())
      }
    }

    outline(depth: 3, indent: true)
    pagebreak(weak: true)
  }

  let body = {
    set heading(numbering: (..args) => if args.pos().len() < 4 {
      numbering("1.1", ..args)
    })

    set par(justify: true)
    show list: set par(justify: false)
    show enum: set par(justify: false)
    show terms: set par(justify: false)
    show table: set par(justify: false)
    show raw.where(block: true): set par(justify: false)

    show cite: text.with(fill: purple)
    show link: text.with(fill: blue)

    body
  }

  let bibliography-page = page(bib)

  let glossary-page = if glossary != none {
    // 1. glossary/acronyms impl
    show terms: it => {
      for item in it.children {
        let term-label = label("gls:" + item.term.text.replace(" ", "-"))
        let term = [#item.term]
        [*#term:* #item.description #metadata((term: term, descr: item.description)) #term-label\ ]
      }
    }

    heading[Glossar]
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

    heading[Abkürzungen]
    acronyms
  }

  let listings-pages = {
    show outline: set heading(outlined: true)
    listings.map(listing => {
      outline(target: figure.where(kind: listing.target), title: listing.title)
    })
    .join(pagebreak(weak: true))
  }

  let appendices-page = if appendices != none {
    set heading(numbering: utils.number-appendices, supplement: [Anhang])

    heading[Anhang]
    (appendices,).flatten().join(pagebreak(weak: true))
  }

  let acknowledgement-page = if acknowledgement != none {
    heading[Danksagung]
    acknowledgement
  }

  let independence-page = if independence == auto {
    heading[Eigenständigkeitserklärung]
    [
      Ich, #meta.author, versichere hiermit, dass ich die vorliegende #kind-to-name(meta.kind) mit dem Thema
      #align(center, emph(meta.title))
      selbstständig und nur unter Verwendung der angegebenen Quellen und Hilfsmittel angefertigt habe.
    ]
  
    align(right)[
      Erfurt, #utils.format-date(meta.date)
    ]
    meta.author
  } else if type(independence) == content {
    heading[Eigenständigkeitserklärung]
    independence
  }

  set page("a4", margin: (inside: 4cm, outside: 3cm, top: 3.5cm, bottom: 2.5cm))

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

  set text(font: "New Computer Modern")
  show heading: set block(above: 1.4em, below: 1em)
  show heading.where(level: 1): set text(font: "Latin Modern Sans")

  title-page
  abstract-pages

  set page(
    "a4",
    header: packages.anti-matter.anti-header(spec, {
      [Fachhochschule Erfurt]
      h(1fr)
      meta.field
      v(-0.5em)
      line(length: 100%)
      counter(footnote).update(0)
    }),
  )
  show heading.where(level: 1): it => pagebreak(weak: true) + it
  show figure.where(kind: table): set figure.caption(position: top)

  let raw-bg = rgb("#f9f5d7")
  set raw(theme: "/assets/themes/gruvbox-light.tmTheme")

  show raw.where(block: false): box.with(fill: raw-bg, inset: (x: 0.25em), outset: (y: 0.25em), radius: 0.25em)
  show raw.where(block: true): set block(width: 100%, fill: raw-bg, inset: 1em, radius: 0.5em)

  set math.equation(numbering: "(1)")
  set math.mat(delim: "[")

  show: packages.anti-matter.anti-matter

  outline-page
  if listing-position == start {
    listings-pages
  }
  packages.anti-matter.anti-front-end()

  body
  packages.anti-matter.anti-inner-end()

  bibliography-page
  glossary-page
  acronyms-page
  if listing-position == end {
    listings-pages
  }
  appendices-page

  if is-kind-thesis(meta.kind) {
    acknowledgement-page
  }

  if is-kind-thesis(meta.kind) {
    independence-page
  }
}
