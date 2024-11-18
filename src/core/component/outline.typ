#import "/src/ctx.typ" as _ctx

#let outline(
  target: image,
  title: auto,
  force-empty: false,
  ctx: _ctx.default,
) = context {
  if force-empty or query(figure.where(kind: target)).filter(f => f.caption != none).len() != 0 {
    show std.outline: set heading(numbering: none, outlined: true, offset: 0)

    ctx.states.in-outline.update(true)
    outline(target: figure.where(kind: target), title: title)
    ctx.states.in-outline.update(false)
  }
}

#let outlines(
  outlines: (
    (targe: image, title: [Abbildungsverzeichnis]),
    (targe: raw,   title: [Listingverzeichnis]),
    (targe: table, title: [Tabellenverzeichnis]),
  ),
  force-empty: false,
  ctx: _ctx.default,
) = {
  outlines.map(((target, title)) => {
    outline(
      force-empty: force-empty,
      target: target,
      title: title,
      ctx: ctx,
    )
  }).join(pagebreak(weak: true))
}
