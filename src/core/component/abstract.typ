#import "/src/ctx.typ" as _ctx

#let abstract(
  title: "Abstract",
  body: lorem(100),
  ctx: _ctx.default,
) = {
  set align(horizon)
  set par(justify: true)
  set heading(numbering: none, outlined: false, offset: 0)
  show heading: set text(16pt, font: ctx.fonts.sans)
  show heading: set block(below: 1.8em)

  heading(level: 1, title)
  body
}

#let abstracts(
  abstracts: (
    (title: "Kurzfassung", body: lorem(100)),
    (title: "Abstract", body: lorem(100)),
  ),
  ctx: _ctx.default,
) = {
  abstracts.map(((title, body)) => {
    abstract(title: title, body: body, ctx: ctx)
  }).join(pagebreak(weak: true))
}

