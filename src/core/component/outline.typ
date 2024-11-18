#import "/src/ctx.typ" as _ctx

#let make-outline(
  target: image,
  title: auto,
  force-empty: false,
  ctx: _ctx.default,
) = context {
  if force-empty or query(figure.where(kind: target)).filter(f => f.caption != none).len() != 0 {
    show outline: set heading(numbering: none, outlined: true, offset: 0)

    ctx.states.in-outline.update(true)
    outline(target: figure.where(kind: target), title: title)
    ctx.states.in-outline.update(false)
  }
}
