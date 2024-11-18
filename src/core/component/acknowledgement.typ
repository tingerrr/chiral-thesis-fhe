#import "/src/ctx.typ" as _ctx

#let make-acknowledgement(body: lorem(100), ctx: _ctx.default) = {
  heading(level: 1)[Danksagung]
  body
}
