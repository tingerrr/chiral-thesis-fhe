#import "/src/utils.typ" as _utils

#let make-abstract(
  title: "Abstract",
  body: lorem(100),
  _fonts: (:),
) = {
  _utils.assert.text("body", body)

  set align(horizon)
  set heading(numbering: none, outlined: false, offset: 0)
  show heading: set text(16pt, font: _fonts.sans)
  show heading: set block(below: 1.8em)

  heading(level: 1, title)
  par(justify: true, body)
}
