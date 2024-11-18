#import "/src/core/authors.typ" as _authors
#import "/src/core/kinds.typ" as _kinds

#import "/src/ctx.typ" as _ctx
#import "/src/utils.typ" as _utils

// TODO: proper handling of more than one author
// TODO: stable positioning
// TODO: use subtitle
#let title-page(
  kind: (:),
  ctx: _ctx.default,
) = {
  set align(center + top)
  stack(
    align(right, image("/assets/images/logo-fhe.svg", width: 45%)),
    5em,
    text(16pt, font: ctx.fonts.sans, strong[
      #kind.kind.name \
      #kind.field
    ]),
    ..if _kinds.is-thesis(kind.kind) { (1em, [Nr. #kind.id]) },
    5em,
    text(32pt, font: ctx.fonts.sans, strong(kind.title)),
    3.4em,
    text(16pt, strong(_authors.format-author(kind.author, email: false))),
    2.5em,
    text(18pt)[Abgabedatum: #_utils.format-date(kind.date)],
  )

  if _kinds.is-thesis(kind.kind) {
    place(center + bottom, text(
      18pt,
      kind.supervisors.map(_authors.format-author.with(email: false)).join(linebreak()),
    ))
  }

  pagebreak(weak: true)
}
