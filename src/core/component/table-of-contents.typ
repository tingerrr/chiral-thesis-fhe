#import "/src/ctx.typ" as _ctx

#let table-of-contents(ctx: _ctx.default) = {
  show outline.entry: it => {
    if it.level == 1 {
      block(above: 18pt, strong({
        let body = if ctx.states.in-appendix.at(it.element.location()) and it.element.numbering != none {
          it.element.body
          [ ]
          numbering(it.element.numbering, ..counter(it.element.func()).at(it.element.location()))
        } else {
          it.body()
        }
        link(it.element.location(), text(font: ctx.fonts.sans, body))
        h(1fr)
        it.page()
      }))
    } else {
      it
    }
  }

  show outline: set heading(numbering: none, outlined: false, offset: 0)

  ctx.states.in-outline.update(true)
  outline(depth: 3, indent: auto)
  ctx.states.in-outline.update(false)
}
