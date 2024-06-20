#import "/src/utils.typ" as _utils

// TODO: separate optional and mandatory styling, let the user control optional styling

#let _std = (
  heading: heading,
  raw: raw,
  table: table,
  figure: figure,
  math: math,
  bibliography: bibliography,
  outline: outline,
)

#let outline(
  _fonts: (:),
) = body => {
  set _std.outline(fill: repeat("  .  "))

  show _std.outline.entry: it => {
    link(it.element.location(), it.body)
    [ ]
    box(width: 1fr, it.fill)
    [ ]
    box(
      width: measure[999].width,
      align(right, it.page),
    )
  }

  body
}

#let global(
  _fonts: (:),
) = body => {
  // TODO: do we provide the fonts within the scaffold?
  set text(lang: "de", size: 11pt, font: _fonts.serif, fallback: false)

  // TODO: should this really be global?
  set page("a4", margin: (inside: 4cm, outside: 3cm, top: 2.5cm, bottom: 2.5cm))

  body
}

#let content(
  _fonts: (:),
) = body => {
  // number headings up to depth 4
  show _std.heading.where(level: 1): set _std.heading(numbering: "1.1", supplement: [Kapitel])
  show _std.heading.where(level: 2): set _std.heading(numbering: "1.1")
  show _std.heading.where(level: 3): set _std.heading(numbering: "1.1")
  show _std.heading.where(level: 4): set _std.heading(numbering: "1.1")

  // turn on justification eveyrwhere except for specific elements
  set par(justify: true)
  // show list: set par(justify: false)
  // show enum: set par(justify: false)
  // show terms: set par(justify: false)
  show table: set par(justify: false)
  show _std.raw.where(block: true): set par(justify: false)

  // NOTE: this currently interferes due to a lack style rules revoking support
  // show links in eastern
  // show link: text.with(fill: eastern)

  // always use quotes
  show quote.where(block: true): set quote(quotes: true)

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
  show _std.heading.where(level: 1): it => pagebreak(weak: true) + it

  // allow users to use the syntax sugar for sections, but disable this for elemens which
  // produce their own headings
  set _std.heading(offset: 1)

  // other mandated style rules
  show _std.heading: set block(above: 1.4em, below: 1.8em)
  show _std.heading: set text(font: _fonts.sans)

  // show outline headings, show them without offset
  show _std.outline: set _std.heading(outlined: true, offset: 0)

  body
}

#let raw(theme: none, _fonts: (:)) = body => {
  set _std.raw(theme: theme) if theme != none

  // use the specified mono font
  show _std.raw: set text(font: _fonts.mono)

  show _std.raw.where(block: true): set block(
    width: 100%,
    inset: 1em,
    stroke: (top: black + 0.5pt, bottom: black + 0.5pt),
  )

  // add outset line numbers
  show _std.raw.where(block: true): it => {
    show _std.raw.line: it => {
      let num = [#it.number]
      box(height: 1em, {
        place(left, dx: -(measure(num).width + 1.5em), align(right, num))
        it
      })
    }

    it
  }

  // TODO: for as long as we can't remove styles easilty, this will make fletcher diagrams look horrible

  // inline raw gets a faint light gray background box to be easier to distinguish
  // show _std.raw.where(block: false): it => box(
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
  show _std.table.cell.where(y: 0): strong
  set _std.table(stroke: (_, y) => if y == 0 {
    (bottom: 0.5pt)
  })

  // add a stronger top and bottom hline
  show _std.table: block.with(stroke: (bottom: black, top: black))

  body
}

#let figure(kinds: (image, raw, table), _fonts: (:)) = body => {
  // default to 1-1 numbering
  set _std.figure(numbering: n => _utils.chapter-relative-numbering("1-1", n))

  // use no gap
  set _std.figure(gap: 0pt)

  // reset all figure counters on chapters
  show _std.heading.where(level: 1): it => {
    kinds.map(k => counter(_std.figure.where(kind: k)).update(0)).join()
    it
  }

  // allow all figures to break by default
  show _std.figure: set block(breakable: true)

  // caption placement is generally below for unknown kinds and images, but above for tables,
  // listings and equations, while equations are generally not put into figures, they do have
  // specific stylistic rules
  show _std.figure: it => {
    let body = block(width: 100%, {
      if _std.figure.caption.position == top and it.caption != none {
        it.caption
        v(it.gap)
      }
      align(center, it.body)
      if _std.figure.caption.position == bottom and it.caption != none {
        v(it.gap)
        it.caption
      }
    })

    if it.placement != none {
      place(it.placement, body)
    } else {
      body
    }
  }
  set _std.figure.caption(position: bottom)
  show _std.figure.where(kind: _std.raw): set _std.figure.caption(position: top)
  show _std.figure.where(kind: _std.table): set _std.figure.caption(position: top)
  show _std.figure.where(kind: math.equation): set _std.figure.caption(position: top)

  // equations are numbered 1.1
  show _std.figure.where(kind: math.equation): set _std.figure(
    numbering: n => _utils.chapter-relative-numbering("1.1", n),
  )

  // captions are generally emph and light gray and in a sans serif font
  show _std.figure.caption: emph
  show _std.figure.caption: set text(fill: gray, font: _fonts.sans)

  body
}

#let math() = body => {
  // default to 1.1 numbering
  set _std.math.equation(numbering: n => _utils.chapter-relative-numbering("(1.1)", n))

  // reset equation counters on chapters
  show _std.heading.where(level: 1): it => counter(_std.math.equation).update(0) + it

  // use bracket as default matrix delimiter
  set _std.math.mat(delim: "[")

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
  show _std.bibliography: it => {
    let re = regex("\[(\w{2,3}\+?\d{2})\]")
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
