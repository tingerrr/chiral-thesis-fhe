#import "/src/core/authors.typ" as _authors
#import "/src/core/kinds.typ" as _kinds
#import "/src/ctx.typ" as _ctx
#import "/src/utils.typ" as _utils

// TODO: proper handling of more than one author
// TODO: stable positioning
// TODO: use subtitle
#let title-page(
  doc: (:),
  ctx: _ctx.default,
) = {
  set align(center + top)
  stack(
    align(right, image("/assets/images/logo-fhe.svg", width: 45%)),
    5em,
    text(16pt, font: ctx.fonts.sans, strong[
      #doc.kind.name \
      #doc.faculty
    ]),
    ..if _kinds.is-thesis(doc.kind) { (1em, [Nr. #doc.id]) },
    5em,
    text(32pt, font: ctx.fonts.sans, strong(doc.title)),
    3.4em,
    text(16pt, strong(_authors.format-author(doc.author, email: false))),
    2.5em,
    text(18pt)[Abgabedatum: #_utils.format-date(doc.date)],
  )

  if _kinds.is-thesis(doc.kind) {
    place(center + bottom, text(
      18pt,
      doc.supervisors.map(_authors.format-author.with(email: false)).join(linebreak()),
    ))
  }

  pagebreak(weak: true)
}
