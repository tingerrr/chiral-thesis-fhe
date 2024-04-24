#let (
  chapter,
  q,
  doc,
  report,
  bachelors-thesis,
  masters-thesis,
) = {
  import "core.typ" as _core

  let chapter = heading.with(level: 1, supplement: [Kapitel])

  // used in quotes
  let q(body) = [\[#body\]]

  (
    chapter,
    q,
    _core.doc,
    _core.kinds.report,
    _core.kinds.thesis.with(kind: _core.kinds.kinds.thesis-bachelor),
    _core.kinds.thesis.with(kind: _core.kinds.kinds.thesis-master),
  )
}
