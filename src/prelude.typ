#let (
  chapter,
  q,
  doc,
  report,
  bachelors-thesis,
  masters-thesis,
  subpar,
  subpar-grid,
) = {
  import "core.typ" as _core
  import "utils.typ" as _utils
  import "packages.typ" as _pkg

  let chapter = heading.with(level: 1, supplement: [Kapitel])

  // used in quotes
  let q(body) = [\[#body\]]

  let subpar-args = (
    numbering: n => _utils.chapter-relative-numbering("1-1", n),
    numbering-sub-ref: (n, m) => _utils.chapter-relative-numbering("1-1a", n, m),
    show-sub-caption: (_, it) => emph(it),
  )

  (
    chapter,
    q,
    _core.doc,
    _core.kinds.report,
    _core.kinds.thesis.with(kind: _core.kinds.kinds.thesis-bachelor),
    _core.kinds.thesis.with(kind: _core.kinds.kinds.thesis-master),
    _pkg.subpar.subpar.with(..subpar-args),
    _pkg.subpar.subpar-grid.with(..subpar-args),
  )
}
