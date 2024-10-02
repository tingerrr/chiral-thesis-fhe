#import "core/authors.typ"
#import "core/kinds.typ"
#import "core/component.typ"
#import "core/styles.typ"

#import "/src/theme.typ" as _theme
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

#let _front-matter-anchor = <__ctf:marker:front-matter>

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
    show: styles.content(draft: draft, _fonts: _fonts)

    body
  }

  let outlines-pages = if outlines != none and outlines != () {
    // TODO: the example document shows these all on their own page, but without rule revoking removing the heading pagebreak is extremely tedious
    outlines.map(outline => {
      component.make-outline(
        force-empty: outlines-force-empty,
        ..outline,
      )
    }).join(pagebreak(weak: true))
  }

  show: styles.global(draft: draft, _fonts: _fonts)
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

  component.make-title-page(..meta, _fonts: _fonts)

  if abstracts != none {
    // abstracts start on the odd side after the title page
    page[]

    abstracts.map(abstract => {
      component.make-abstract(..abstract, _fonts: _fonts)
    }).join(page[])
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

  // toc starts on an odd page after the abstracts
  pagebreak()
  component.make-table-of-contents(_fonts: _fonts)

  if outlines-position == start {
    outlines-pages
  }

  // an anchor to retreive the page number we left off with for later
  _utils.marker(_front-matter-anchor)

  // use arabic numbering
  set page(numbering: "1")
  counter(page).update(1)
  body

  // revert back to roman numbring, continuing where we left off
  set page(numbering: "I")
  context counter(page).update(counter(page).at(_front-matter-anchor).first() + 1)

  // TODO: is there any need for specific handling like with the other struture elements? the if is currently redundant
  if bibliography != none {
    bibliography
  }

  if outlines-position == end {
    outlines-pages
  }

  if glossary != none {
    component.make-glossary(entries: glossary, _fonts: _fonts)
  }

  if appendices != none {
    counter(heading).update(0)
    _utils.state.appendix.update(true)
    appendices.map(appendix => {
      component.make-appendix(body: appendix)
    }).join(pagebreak(weak: true))
    _utils.state.appendix.update(false)
  }

  if kinds.is-thesis(meta.kind) and acknowledgement != none {
    component.make-acknowledgement(body: acknowledgement)
  }

  if kinds.is-thesis(meta.kind) and affidavit != none {
    page[]
    component.make-affidavit(
      title: meta.title,
      author: meta.author,
      date: meta.date,
      body: affidavit,
      kind: meta.kind,
    )
  }
}

// TODO: cleanup of spacing and layout code
// TODO: use FHE AI logo, not just FHE logo
#let poster(
  kind: (:),
  image: none,
  cv: par(justify: true, lorem(75)),
  theme: _theme.themes.applied-computer-science,
  _fonts: _fonts,
) = body => {
  set text(font: _fonts.sans)

  let title = {
    set text(size: 78pt)
    kind.title
  }

  let supervisors = {
    set text(size: 32pt, fill: theme.secondary, weight: "bold")
    [Betreuer: ]
    kind
      .supervisors
      .map(authors.format-author.with(email: false))
      .join(", ", last: " und ")
  }

  let faculty = {
    set text(size: 30pt)
    [
      Studiengang Angewandte Informatik,
      Altonaer Str. 25 99085 Erfurt,
      Tel. 0361 6700 642,
      e-mail: informatik\@fh-erfurt.de
    ]
  }

  let cv = {
    grid(
      columns: (auto, auto, 0pt),
      align: horizon,
      gutter: 3cm,
      block(width: 105mm, height: 140mm, fill: theme.accent-primary),
      {
        text(size: 54pt, strong(
          authors.format-author(kind.author, email: false, titles: false)
        ))
        linebreak()
        text(size: 42pt, cv)
      },
      none
    )
  }

  let separator = theme.secondary + 0.2cm

  set page(
    paper: "a0",
    margin: 0pt,
    background: grid(
      columns: (3cm, 1fr, 13.15cm, 14cm),
      rows: (4.8cm, 11cm, 18cm, 1fr, 4cm),
      align: top + left,
      // header
      grid.cell(fill: theme.accent-primary, none),
      grid.cell(fill: theme.accent-primary, none),
      grid.cell(fill: theme.primary, none),
      grid.cell(fill: theme.accent-primary, none),
      
      // title and logo
      none,
      grid.cell(
        inset: (top: 1.8cm, bottom: 0.9cm),
        {
          set align(top)
          strong(title)
          set align(bottom)
          supervisors
        }
      ),
      grid.cell(
        colspan: 2,
        inset: (top: 1.8cm, right: 1.75cm),
        std.image("/assets/images/logo-fhe.svg", width: 100%)
      ),

      // faculty and cv info
      none,
      // NOTE: since we can't control the alignment of the stroke yet we need to
      // ensure that the top and bottom lines don't protrude on the x axis
      block(
        width: 100%,
        stroke: (top: separator),
        inset: (top: 0.5cm, bottom: 1cm), {
          set align(top)
          faculty
          set align(bottom)
          cv
      }),
      grid.cell(
        rowspan: 2,
        fill: gradient.linear(angle: 90deg, theme.accent-primary, white),
        block(
          width: 100%,
          stroke: (top: separator),
          none,
        ),
      ),
      none,

      // main content
      none,
      block(
        width: 100%,
        stroke: (top: separator),
        none,
      ),
      none, none,

      // footer
      none, none, none,
      grid.cell(fill: theme.accent-secondary, none),
      grid.cell(fill: theme.accent-secondary, none),
      grid.cell(fill: theme.secondary, none),
      grid.cell(fill: theme.accent-secondary, none),
    )
  )

  grid(
    columns: (3cm, 1fr, 3cm),
    rows: (33.8cm, 1fr, 4cm),
    inset: (y: 2cm),
    none, none, none,
    none, body, none,
    none, none, none,
  )
}

