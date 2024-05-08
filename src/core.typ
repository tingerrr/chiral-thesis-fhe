#import "core/authors.typ"
#import "core/kinds.typ"
#import "core/structure.typ"
#import "core/styles.typ"

#import "/src/utils.typ" as _utils

// TODO: lift this into a styling context kind of dictionary.
#let _fonts = (
  // TODO: ncm seems to have issues with some symbols like list markers
  // serif: "New Computer Modern",
  serif: "Linux Libertine",
  // TODO: provide ncms, this is currently not included
  // #let sans = "New Computer Modern Sans"
  sans: "Latin Modern Sans",
  // TODO: provide and use mono font, if another one is expected
  mono: "DejaVu Sans Mono",
)

// TODO: arg validation
// TODO: provide good defaults
#let doc(
  // kind: kinds.report(),
  kind: (:),
  draft: true,
  abstracts: none,
  bibliography: none,
  outlines: (),
  outlines-position: end,
  outlines-force-empty: false,
  glossary: none,
  appendices: none,
  acknowledgement: none,
  affidavit: auto,
) = body => {
  let meta = kind

  let body = {
    show: styles.content(_fonts: _fonts)

    body
  }

  let outlines-pages = if outlines != none and outlines != () {
    outlines.map(outline => {
      structure.make-outline(
        force-empty: outlines-force-empty,
        ..outline,
      )
    }).join(pagebreak(weak: true))
  }

  show: styles.global(_fonts: _fonts)
  show: styles.outline(_fonts: _fonts)

  // TODO: propose this as the default gls supplement behavior or simply fork glossarium if there are more problems
  // show: _utils._pkg.glossarium.make-glossary
  show ref: it => {
    let is-figure = it.element != none and it.element.func() == figure

    if is-figure and it.element.kind == _utils._pkg.glossarium.__glossarium_figure {
      let extra = if it.supplement == [s] {
        (suffix: it.supplement)
      } else if it.supplement not in (none, auto, []) {
        (display: it.supplement)
      }

      _utils._pkg.glossarium.gls(str(it.target), ..extra)
    } else {
      it
    }
  }

  set page(background: {
    set align(center + horizon)
    set text(gray.lighten(85%), 122pt)
    rotate(-45deg)[Entwurf]
  }) if draft

  structure.make-title-page(..meta, _fonts: _fonts)

  if abstracts != none {
    abstracts.map(abstract => {
      structure.make-abstract(..abstract, _fonts: _fonts)
    }).join(pagebreak(weak: true))
  }

  set page(
    header: {
      set text(8pt, font: _fonts.sans)
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
  show: styles.raw(
    theme: "/assets/themes/gruvbox-light.tmTheme",
    fill: rgb("#f9f5d7"),
    plain: true,
    _fonts: _fonts,
  )
  show: styles.math()
  show: styles.figure(kinds: outlines.map(l => l.target), _fonts: _fonts)
  show: styles.bibliography()

  // NOTE: this must currently stay below the figure syles to ensure the fully realized level 1 headings start with their weak pagebreak.
  show: styles.heading(_fonts: _fonts)

  // start with roman numbering after the prelude
  set page(numbering: "I")
  counter(page).update(1)

  structure.make-table-of-contents(
    appendix-marker: <__ctf-appendix-marker>,
    _fonts: _fonts,
  )

  if outlines-position == start {
    outlines-pages
  }

  // an anchor to retreive the page number we left off with for later
  _utils.marker("__ctf-front-matter")

  // use arabic numbering
  set page(numbering: "1")
  counter(page).update(1)
  body

  // revert back to roman numbring, continuing where we left off
  set page(numbering: "I")
  context counter(page).update(counter(page).at(<__ctf-front-matter>).first() + 1)

  // TODO: is there any need for specific handling like with the other struture elements? the if is currently redundant
  if bibliography != none {
    bibliography
  }

  if outlines-position == end {
    outlines-pages
  }

  if glossary != none {
    structure.make-glossary(entries: glossary, _fonts: _fonts)
  }

  if appendices != none {
    counter(heading).update(0)
    _utils.marker("__ctf-appendix-marker")
    appendices.map(appendix => {
      structure.make-appendix(body: appendix)
    }).join(pagebreak(weak: true))
    _utils.marker("__ctf-appendix-marker")
  }

  if kinds.is-thesis(meta.kind) and acknowledgement != none {
    structure.make-acknowledgement(body: acknowledgement)
  }

  if kinds.is-thesis(meta.kind) and affidavit != none {
    structure.make-affidavit(
      title: meta.title,
      author: meta.author,
      date: meta.date,
      body: affidavit,
      kind: meta.kind,
    )
  }
}
