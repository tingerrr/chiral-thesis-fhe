#import "prelude/subpar.typ"

#let (
  // helper funcitons
  chapter,
  q,

  // glossarium re-exports
  gls,
  glspl,

  // template
  doc,

  // kinds
  report,
  bachelors-thesis,
  masters-thesis,
) = {
  import "core.typ" as _core
  import "utils.typ" as _utils

  let chapter = heading.with(level: 1, supplement: [Kapitel])

  // used in quotes
  let q(body) = [\[#body\]]

  (
    chapter,
    q,
    _utils._pkg.glossarium.gls,
    _utils._pkg.glossarium.glspl,
    _core.doc,
    _core.kinds.report,
    _core.kinds.thesis.with(kind: _core.kinds.kinds.thesis-bachelor),
    _core.kinds.thesis.with(kind: _core.kinds.kinds.thesis-master),
  )
}
