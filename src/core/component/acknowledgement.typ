#import "/src/ctx.typ" as _ctx

#let acknowledgement(body: lorem(100), ctx: _ctx.default) = {
  heading(level: 1)[Danksagung]
  set par(justify: true)
  body
}
