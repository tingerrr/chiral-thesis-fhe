#import "/src/utils.typ" as _utils

// TODO: separate optional and mandatory styling, let the user control optional styling

#let _std = (
  heading: heading,
  raw: raw,
  table: table,
  figure: figure,
  math: math,
  bibliography: bibliography,
)

#let global() = body => {
  // TODO: do we provide the fonts within the scaffold?
  // set text(lang: "de", size: 11pt, font: "New Computer Modern", fallback: false)
  set text(lang: "de", size: 11pt, font: "New Computer Modern")

  // TODO: should this really be global?
  set page(paper: "a4", margin: (inside: 4cm, outside: 3cm, top: 2.5cm, bottom: 2.5cm))

  body
}

#let content() = body => {
  // number headings up to depth 4
  show _std.heading.where(level: 1): set _std.heading(numbering: "1.1")
  show _std.heading.where(level: 2): set _std.heading(numbering: "1.1")
  show _std.heading.where(level: 3): set _std.heading(numbering: "1.1")
  show _std.heading.where(level: 4): set _std.heading(numbering: "1.1")

  // turn on justification eveyrwhere except for specific elements
  set par(justify: true)
  show list: set par(justify: false)
  show enum: set par(justify: false)
  show terms: set par(justify: false)
  show table: set par(justify: false)
  show _std.raw.where(block: true): set par(justify: false)

  // show links in eastern
  show link: text.with(fill: eastern)

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

#let heading() = body => {
  // add pagebreaks on chapters
  show _std.heading.where(level: 1): it => pagebreak(weak: true) + it

  // allow users to use the syntax sugar for sections, but disable this for elemens which
  // produce their own headings
  set _std.heading(offset: 1)
  show outline: set _std.heading(offset: 0)

  // other mandated style rules
  show _std.heading: set block(above: 1.4em, below: 1em)
  show _std.heading.where(level: 1): set text(font: "Latin Modern Sans")

  // show outline headings
  show outline: set _std.heading(outlined: true)

  body
}

#let raw(theme: auto, fill: none) = body => {
  // we may set a theme
  set _std.raw(theme: theme) if theme != auto

  // block raw is a rounded block of full width
  show _std.raw.where(block: true): set block(
    fill: fill,
    width: 100%,
    inset: 1em,
    radius: 0.5em,
  )

  // TODO: reduce spacing of lines

  // add outset line numbers
  show _std.raw.where(block: true): it => {
    show _std.raw.line: it => {
      let num = [#it.number]
      place(left, dx: -(measure(num).width + 1.5em), align(right, num))
      it.body
    }

    it
  }

  // inline raw looks similar to block raw, but extends out of the line in y direction
  show _std.raw.where(block: false): box.with(
    fill: fill,
    inset: (x: 0.25em),
    outset: (y: 0.25em),
    radius: 0.25em,
  )

  body
}

#let table() = body => {
  // the page header gets strong text and gets the only hline
  show _std.table.cell.where(y: 0): strong
  set _std.table(stroke: (_, y) => if y == 0 {
    (bottom: 1pt)
  })

  body
}

#let figure(kinds: (image, raw, table)) = body => {
  // default to 1-1 numbering
  set _std.figure(numbering: n => _utils.chapter-relative-numbering("1-1", n))

  // reset all figure counters on chapters
  show _std.heading.where(level: 1): it => {
    kinds.map(k => counter(_std.figure.where(kind: k)).update(0)).join()
    it
  }

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

  // captions are generally emph and light gray
  show _std.figure.caption: emph
  show _std.figure.caption: set text(fill: gray)

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

  // show only the alphanumeric id of the citation in purple
  show cite: it => {
    show regex("\[|\]"): text.with(fill: black)
    show regex("[^\[\]]"): text.with(fill: purple)
    it
  }

  body
}
