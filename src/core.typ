#import "core/authors.typ"
#import "core/kinds.typ"
#import "core/component.typ"
#import "core/styles.typ"

#import "/src/ctx.typ" as _ctx
#import "/src/packages.typ" as _pkg
#import "/src/utils.typ" as _utils

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
  ctx: _ctx.default,
) = body => {
  let meta = kind

  let body = {
    show: styles.content(draft: draft, ctx: ctx)

    body
  }

  let outlines-pages = if outlines != none and outlines != () {
    // TODO: the example document shows these all on their own page, but without rule revoking removing the heading pagebreak is extremely tedious
    outlines.map(outline => {
      component.make-outline(
        force-empty: outlines-force-empty,
        ..outline,
        ctx: ctx,
      )
    }).join(pagebreak(weak: true))
  }

  show: styles.global(draft: draft, ctx: ctx)
  show: styles.outline(ctx: ctx)

  // TODO: propose this as the default gls supplement behavior or simply fork glossarium if there are more problems
  // show: _pkg.glossarium.make-glossary
  show ref: it => {
    let is-figure = it.element != none and it.element.func() == figure

    if is-figure and it.element.kind == _pkg.glossarium.__glossarium_figure {
      let extra = if it.supplement == [s] {
        (suffix: it.supplement)
      } else if it.supplement not in (none, auto, []) {
        (display: it.supplement)
      }

      _pkg.glossarium.gls(str(it.target), ..extra)
    } else {
      it
    }
  }

  component.make-title-page(..meta, ctx: ctx)

  if abstracts != none {
    abstracts.map(abstract => {
      component.make-abstract(..abstract, ctx: ctx)
    }).join(pagebreak(weak: true))
  }

  set page(
    header: context if not _ctx.is-blank-page(ctx: ctx) {
      set text(8pt, font: ctx.fonts.sans)
      [Fachhochschule Erfurt]
      h(1fr)
      meta.field
      v(-0.5em)
      line(length: 100%, stroke: 0.5pt)
      counter(footnote).update(0)
    },
    footer: context if not _ctx.is-blank-page(ctx: ctx) {
      set align(if calc.even(here().page()) { left } else { right })

      if page.numbering != none {
        counter(page).display(page.numbering)
      }
    },
  )

  // TODO: make configurable
  show: styles.table(ctx: ctx)
  show: styles.raw(ctx: ctx)
  show: styles.math(ctx: ctx)
  show: styles.figure(kinds: outlines.map(l => l.target), ctx: ctx)
  show: styles.bibliography(ctx: ctx)

  // NOTE: this must currently stay below the figure syles to ensure the fully realized level 1 headings start with their weak pagebreak.
  show: styles.heading(ctx: ctx)

  // start with roman numbering after the prelude
  set page(numbering: "I")
  counter(page).update(1)

  component.make-table-of-contents(ctx: ctx)

  if outlines-position == start {
    outlines-pages
  }

  // an anchor to retreive the page number we left off with for later
  _ctx.marker(ctx.labels.front-matter-anchor)

  // use arabic numbering
  set page(numbering: "1")
  counter(page).update(1)
  body

  // revert back to roman numbring, continuing where we left off
  set page(numbering: "I")
  context counter(page).update(counter(page).at(ctx.labels.front-matter-anchor).first() + 1)

  // TODO: is there any need for specific handling like with the other struture elements? the if is currently redundant
  if bibliography != none {
    bibliography
  }

  if outlines-position == end {
    outlines-pages
  }

  if glossary != none {
    component.make-glossary(entries: glossary, ctx: ctx)
  }

  if appendices != none {
    counter(heading).update(0)
    appendices.map(appendix => {
      component.make-appendix(body: appendix, ctx: ctx)
    }).join(pagebreak(weak: true))
  }

  if kinds.is-thesis(meta.kind) and acknowledgement != none {
    component.make-acknowledgement(body: acknowledgement, ctx: ctx)
  }

  if kinds.is-thesis(meta.kind) and affidavit != none {
    component.make-affidavit(
      title: meta.title,
      author: meta.author,
      date: meta.date,
      body: affidavit,
      kind: meta.kind,
      ctx: ctx,
    )
  }
}
