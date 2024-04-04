#import "/src/core/kinds.typ" as _kinds
#import "/src/core/authors.typ" as _authors
#import "/src/utils.typ" as _utils

// TODO: proper handling of more than one author
// TODO: stable positioning
// TODO: use subtitle
#let make-title-page(
  title: "Mustertitel",
  subtitle: none,
  author: "Mustermann, Max",
  supervisors: (
    "Prof. Dr. Max Mustermann",
    "Prof. Dr. Maxine Musterfrau",
  ),
  field: "Angewandte Informatik",
  date: datetime.today(),
  id: "AI-1970-BA-999",
  kind: _kinds.report,
  // fhe-logo: none,
) = {
    set align(center + top)
    stack(
      align(right, image("/assets/images/logo-fhe.svg", width: 45%)),
      5em,
      text(16pt, strong[
        #kind.name \
        #field
      ]),
      ..if _kinds.is-thesis(kind) { (1em, [Nr. #id]) },
      5em,
      text(32pt, font: "Latin Modern Sans", strong(title)),
      3.4em,
      text(16pt, strong(_authors.format-author(author, email: false))),
      2.5em,
      text(18pt)[Abgabedatum: #_utils.format-date(date)],
    )

    if _kinds.is-thesis(kind) {
      place(center + bottom, text(
        18pt,
        supervisors.map(_authors.format-author.with(email: false)).join(linebreak()),
      ))
    }

    pagebreak(weak: true)
  }
