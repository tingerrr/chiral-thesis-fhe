#import "/src/ctx.typ" as _ctx
#import "/src/utils.typ" as _utils

// NOTE: because we re-use plenty of standard library definition's identifiers, we use `std.` to
// defensively to avoid bugs when introducing new styles

// TODO: separate optional and mandatory styling, let the user control optional styling

#let outline(
  ctx: _ctx.default,
) = body => {
  set std.outline(fill: std.repeat("  .  "))

  show std.outline.entry: it => {
    std.link(it.element.location(), it.body)
    [ ]
    std.box(width: 1fr, it.fill)
    [ ]
    context box(
      width: std.measure[999].width,
      std.align(std.right, it.page),
    )
  }

  body
}

#let global(
  draft: false,
  ctx: _ctx.default,
) = body => {
  // TODO: do we provide the fonts within the scaffold?
  set std.text(lang: "de", size: 11pt, font: ctx.fonts.serif, fallback: false)

  // move content left by 1cm in draft mode, this doesn't affect vertical layout
  // and allows reviwers to place notes in the right margin
  let margin = (top: 2.5cm, bottom: 2.5cm) + if draft {
    (right: 5cm, left: 2cm)
  } else {
    (inside: 4cm, outside: 3cm)
  }

  let background = {
    // add a watermark to the background which cannot be selected as text
    if draft {
      set std.align(std.center + std.horizon)
      set std.text(std.gray.lighten(85%), 122pt)
      std.rotate(-45deg, std.image("/assets/images/draft-watermark.svg"))
    }

    // add the blank page notice above the water mark if it exists
    context if _ctx.is-blank-page(ctx: ctx) {
      std.place(std.center + std.horizon)[this page is intentionally left blank]
    }
  }

  set std.page("a4", margin: margin, background: background)

  show std.pagebreak: it => {
    _ctx.marker(ctx.labels.pagebreak.start)
    it
    _ctx.marker(ctx.labels.pagebreak.end)
  }
  set page(paper: "a4", margin: margin, background: background)

  body
}

#let content(
  draft: false,
  ctx: _ctx.default,
) = body => {
  // number headings up to depth 4
  show std.heading.where(level: 1): set std.heading(numbering: "1.1", supplement: [Kapitel])
  show std.heading.where(level: 2): set std.heading(numbering: "1.1")
  show std.heading.where(level: 3): set std.heading(numbering: "1.1")
  show std.heading.where(level: 4): set std.heading(numbering: "1.1")

  // show page relative line numbers in draft mode
  set std.par.line(
    numbering: n => std.text(std.gray, numbering("1", n)),
    numbering-scope: "page",
  ) if draft

  // don't show any line numbers for figures, listings, equations or headings
  // these generally look bad and are already easy to reference
  show std.heading: set std.par.line(numbering: none)
  show std.figure: set std.par.line(numbering: none)
  show std.table: set std.par.line(numbering: none)
  show std.math.equation: set std.par.line(numbering: none)

  // turn on justification everywhere except for specific elements
  set std.par(justify: true)
  show std.table: set std.par(justify: false)
  show std.raw.where(block: true): set std.par(justify: false)

  // NOTE: this currently interferes due to a lack style rules revoking support
  // show links in eastern
  // show link: text.with(fill: eastern)

  // always use quotes
  set std.quote(quotes: true)

  // show attribution also for inline quotes
  show std.quote.where(block: false): it => {
    ["#it.body"]
    let attr = it.attribution
    if std.type(attr) == std.label {
      attr = std.cite(it.attribution)
    }
    [ ]
    attr
  }

  body
}

#let heading(ctx: _ctx.default) = body => {
  // add pagebreaks on chapters
  show std.heading.where(level: 1): it => std.pagebreak(weak: true) + it

  // allow users to use the syntax sugar for sections, but disable this for elemens which
  // produce their own headings
  set std.heading(offset: 1)

  // other mandated style rules
  show std.heading: set std.block(above: 1.4em, below: 1.8em)
  show std.heading: set std.text(font: ctx.fonts.sans)

  // show outline and bibliography headings without offset
  show std.outline: set std.heading(outlined: true, offset: 0)
  show std.bibliography: set std.heading(offset: 0)

  body
}

#let raw(ctx: _ctx.default) = body => {
  // use the specified mono font
  show std.raw: set std.text(font: ctx.fonts.mono)

  show std.raw.where(block: true): set std.block(
    width: 100%,
    inset: 1em,
    stroke: (top: std.black + 0.5pt, bottom: std.black + 0.5pt),
  )

  // add outset line numbers
  show std.raw.where(block: true): it => {
    show std.raw.line: it => {
      let num = [#it.number]
      std.box(height: 1em, {
        context std.place(
          std.left,
          dx: -(std.measure(num).width + 1.5em),
          std.align(std.right, num),
        )
        it
      })
    }

    it
  }

  // TODO: for as long as we can't remove styles easily, this will make fletcher diagrams look horrible

  // inline raw gets a faint light gray background box to be easier to distinguish
  // show std.raw.where(block: false): it => std.box(
  //   fill: std.gray.lighten(75%),
  //   inset: (x: 0.25em),
  //   outset: (y: 0.25em),
  //   radius: 0.25em,
  //   it,
  // )

  body
}

#let table(ctx: _ctx.default) = body => {
  // the page header gets strong text and gets the a bottom hline
  show std.table.cell.where(y: 0): std.strong
  set std.table(stroke: (_, y) => if y == 0 {
    (bottom: 0.5pt)
  })

  // add a stronger top and bottom hline
  show std.table: std.block.with(stroke: (bottom: std.black, top: std.black))

  body
}

#let figure(kinds: (std.image, std.raw, std.table), ctx: _ctx.default) = body => {
  // default to 1-1 numbering
  set std.figure(numbering: n => _utils.chapter-relative-numbering("1-1", n))

  // use no gap
  set std.figure(gap: 0pt)

  // reset all figure counters on chapters
  show std.heading.where(level: 1): it => {
    kinds.map(k => std.counter(std.figure.where(kind: k)).update(0)).join()
    it
  }

  // allow all figures to break by default
  show std.figure: set std.block(breakable: true)

  // caption placement is generally below for unknown kinds and images, but above for tables,
  // listings and equations, while equations are generally not put into figures, they do have
  // specific stylistic rules
  show std.figure: it => {
    let body = std.block(width: 100%, {
      if std.figure.caption.position == std.top and it.caption != none {
        std.align(std.left, it.caption)
        std.v(it.gap)
      }
      std.align(std.center, it.body)
      if std.figure.caption.position == std.bottom and it.caption != none {
        std.v(it.gap)
        std.align(std.left, it.caption)
      }
    })

    if it.placement == auto {
      std.place(it.placement, float: true, body)
    } else if it.placement != none {
      std.place(it.placement, body)
    } else {
      body
    }
  }
  set std.figure.caption(position: std.bottom)
  show std.figure.where(kind: std.raw): set std.figure.caption(position: std.top)
  show std.figure.where(kind: std.table): set std.figure.caption(position: std.top)
  show std.figure.where(kind: std.math.equation): set std.figure.caption(position: std.top)

  // equations are numbered 1.1
  show std.figure.where(kind: std.math.equation): set std.figure(
    numbering: n => _utils.chapter-relative-numbering("1.1", n),
  )

  // captions are generally emph and light gray and in a sans serif font
  show std.figure.caption: std.emph
  show std.figure.caption: set std.text(fill: std.gray, font: ctx.fonts.sans)

  body
}

#let math(ctx: _ctx.default) = body => {
  // default to 1.1 numbering
  set std.math.equation(numbering: n => _utils.chapter-relative-numbering("(1.1)", n))

  // reset equation counters on chapters
  show std.heading.where(level: 1): it => std.counter(std.math.equation).update(0) + it

  // use bracket as default matrix delimiter
  set std.math.mat(delim: "[")

  body
}

#let bibliography(ctx: _ctx.default) = body => {
  // use alphanumeric citation style, not ieee
  set std.cite(style: "alphanumeric")

  // BUG: this prevents the formation of cite groups

  // show only the alphanumeric id of the citation in the given color and don't
  // ignore the supplement
  show std.cite.where(form: "normal"): it => {
    "["
    std.text(ctx.colors.cite, std.cite(form: "full", it.key))
    if it.supplement != none {
      [, ]
      it.supplement
    }
    "]"
  }

  // apply the same style within the bibliography back references
  show std.bibliography: it => {
    let re = std.regex("\[([\w\-]{2,3}\+?\d{2})\]")
    show re: it => {
      let m = it.text.match(re)
      "["
      std.text(ctx.colors.cite, m.captures.first())
      "]"
    }
    it
  }

  body
}
