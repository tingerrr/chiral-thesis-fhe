#import "/src/ctx.typ" as _ctx

#let make-abstract(
  title: "Abstract",
  body: lorem(100),
  ctx: _ctx.default,
) = {
  set align(horizon)
  set heading(numbering: none, outlined: false, offset: 0)
  show heading: set text(16pt, font: ctx.fonts.sans)
  show heading: set block(below: 1.8em)

  heading(level: 1, title)
  par(justify: true, body)
}
