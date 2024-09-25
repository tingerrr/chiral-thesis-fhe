#import "/src/utils.typ" as _utils

// TODO: separate optional and mandatory styling, let the user control optional styling

#let outline(
  _fonts: (:),
) = body => {
  set std.outline(fill: repeat("  .  "))

  show std.outline.entry: it => {
    link(it.element.location(), it.body)
    [ ]
    box(width: 1fr, it.fill)
    [ ]
    context box(
      width: measure[999].width,
      align(right, it.page),
    )
  }

  body
}

#let global(
  draft: false,
  _fonts: (:),
) = body => {
  // TODO: do we provide the fonts within the scaffold?
  set text(lang: "de", size: 11pt, font: _fonts.serif, fallback: false)

  // move content left by 1cm in draft mode, this doesn't affect vertical layout
  // and allows reviwers to place notes in the right margin
  let margin = (top: 2.5cm, bottom: 2.5cm) + if draft {
    (right: 5cm, left: 2cm)
  } else {
    (inside: 4cm, outside: 3cm)
  }

  // add a watermark to the background which cannot be selected as text
  let background = if draft {
    set align(center + horizon)
    set text(gray.lighten(85%), 122pt)
    rotate(-45deg, image("/assets/images/draft-watermark.svg"))
  }

  set page("a4", margin: margin, background: background)

  body
}

#let content(
  draft: false,
  _fonts: (:),
) = body => {
  // number headings up to depth 4
  show std.heading.where(level: 1): set std.heading(numbering: "1.1", supplement: [Kapitel])
  show std.heading.where(level: 2): set std.heading(numbering: "1.1")
  show std.heading.where(level: 3): set std.heading(numbering: "1.1")
  show std.heading.where(level: 4): set std.heading(numbering: "1.1")

  // show page relative line numbers in draft mode
  set par.line(
    numbering: n => text(gray, numbering("1", n)),
    numbering-scope: "page",
  ) if draft

  // don't show any line numbers for figures, listings, equations or headings
  // these generally look bad and are already easy to reference
  show std.heading: set par.line(numbering: none)
  show std.figure: set par.line(numbering: none)
  show std.table: set par.line(numbering: none)
  show math.equation: set par.line(numbering: none)

  // turn on justification eveyrwhere except for specific elements
  set par(justify: true)
  show std.table: set par(justify: false)
  show std.raw.where(block: true): set par(justify: false)

  // NOTE: this currently interferes due to a lack style rules revoking support
  // show links in eastern
  // show link: text.with(fill: eastern)

  // always use quotes
  set quote(quotes: true)

  // show attribution also for inline quotes
  show quote.where(block: false): it => {
    ["#it.body"]
    let attr = it.attribution
    if type(attr) == label {
      attr = cite(it.attribution)
    }
    [ ]
    attr
  }

  body
}

#let heading(_fonts: (:)) = body => {
  // add pagebreaks on chapters
  show std.heading.where(level: 1): it => pagebreak(weak: true) + it

  // allow users to use the syntax sugar for sections, but disable this for elemens which
  // produce their own headings
  set std.heading(offset: 1)

  // other mandated style rules
  show std.heading: set block(above: 1.4em, below: 1.8em)
  show std.heading: set text(font: _fonts.sans)

  // show outline and bibliography headings without offset
  show std.outline: set std.heading(outlined: true, offset: 0)
  show std.bibliography: set std.heading(offset: 0)

  body
}

#let raw(theme: none, _fonts: (:)) = body => {
  set std.raw(theme: theme) if theme != none

  // use the specified mono font
  show std.raw: set text(font: _fonts.mono)

  show std.raw.where(block: true): set block(
    width: 100%,
    inset: 1em,
    stroke: (top: black + 0.5pt, bottom: black + 0.5pt),
  )

  // add outset line numbers
  show std.raw.where(block: true): it => {
    show std.raw.line: it => {
      let num = [#it.number]
      box(height: 1em, {
        context place(left, dx: -(measure(num).width + 1.5em), align(right, num))
        it
      })
    }

    it
  }

  // TODO: for as long as we can't remove styles easily, this will make fletcher diagrams look horrible

  // inline raw gets a faint light gray background box to be easier to distinguish
  // show std.raw.where(block: false): it => box(
  //   fill: gray.lighten(75%),
  //   inset: (x: 0.25em),
  //   outset: (y: 0.25em),
  //   radius: 0.25em,
  //   it,
  // )

  body
}

#let table() = body => {
  // the page header gets strong text and gets the a bottom hline
  show std.table.cell.where(y: 0): strong
  set std.table(stroke: (_, y) => if y == 0 {
    (bottom: 0.5pt)
  })

  // add a stronger top and bottom hline
  show std.table: block.with(stroke: (bottom: black, top: black))

  body
}

#let figure(kinds: (image, raw, table), _fonts: (:)) = body => {
  // default to 1-1 numbering
  set std.figure(numbering: n => _utils.chapter-relative-numbering("1-1", n))

  // use no gap
  set std.figure(gap: 0pt)

  // reset all figure counters on chapters
  show std.heading.where(level: 1): it => {
    kinds.map(k => counter(std.figure.where(kind: k)).update(0)).join()
    it
  }

  // allow all figures to break by default
  show std.figure: set block(breakable: true)

  // caption placement is generally below for unknown kinds and images, but above for tables,
  // listings and equations, while equations are generally not put into figures, they do have
  // specific stylistic rules
  show std.figure: it => {
    let body = block(width: 100%, {
      if std.figure.caption.position == top and it.caption != none {
        align(left, it.caption)
        v(it.gap)
      }
      align(center, it.body)
      if std.figure.caption.position == bottom and it.caption != none {
        v(it.gap)
        align(left, it.caption)
      }
    })

    if it.placement == auto {
      place(it.placement, float: true, body)
    } else if it.placement != none {
      place(it.placement, body)
    } else {
      body
    }
  }
  set std.figure.caption(position: bottom)
  show std.figure.where(kind: std.raw): set std.figure.caption(position: top)
  show std.figure.where(kind: std.table): set std.figure.caption(position: top)
  show std.figure.where(kind: math.equation): set std.figure.caption(position: top)

  // equations are numbered 1.1
  show std.figure.where(kind: math.equation): set std.figure(
    numbering: n => _utils.chapter-relative-numbering("1.1", n),
  )

  // captions are generally emph and light gray and in a sans serif font
  show std.figure.caption: emph
  show std.figure.caption: set text(fill: gray, font: _fonts.sans)

  body
}

#let math() = body => {
  // default to 1.1 numbering
  set std.math.equation(numbering: n => _utils.chapter-relative-numbering("(1.1)", n))

  // reset equation counters on chapters
  show std.heading.where(level: 1): it => counter(std.math.equation).update(0) + it

  // use bracket as default matrix delimiter
  set std.math.mat(delim: "[")

  body
}

#let bibliography() = body => {
  // use alphanumeric citation style, not ieee
  set cite(style: "alphanumeric")

  // BUG: this prevents the formation of cite groups

  // show only the alphanumeric id of the citation in purple and don't ignore the supplement
  show cite.where(form: "normal"): it => {
    "["
    text(purple, cite(form: "full", it.key))
    if it.supplement != none {
      [, ]
      it.supplement
    }
    "]"
  }

  // apply the same style within the bibliography back references
  show std.bibliography: it => {
    let re = regex("\[([\w\-]{2,3}\+?\d{2})\]")
    show re: it => {
      let m = it.text.match(re)
      "["
      text(purple, m.captures.first())
      "]"
    }
    it
  }

  body
}
