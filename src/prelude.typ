#let (
  chapter,
  q,
  doc,
  report,
  bachelors-thesis,
  masters-thesis,
) = {
  import "core.typ"
  import "kinds.typ"

  let chapter = heading.with(level: 1)

  // used in quotes
  let q(body) = [\[#body\]]

  (
    chapter,
    q,
    core.doc,
    kinds.report,
    kinds.thesis.with(kind: kinds.kinds.thesis-bachelor),
    kinds.thesis.with(kind: kinds.kinds.thesis-master),
  )
}
