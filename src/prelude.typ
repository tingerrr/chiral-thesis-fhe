// NOTE: these are largely used for styling configuration which will be done
// with set rules once custom types exist
#import "prelude/subpar.typ"

#let (
  // helper functions
  chapter,
  q,
  i18n,

  // glossarium re-exports
  glossarium,
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

  (
    _utils.chapter,
    _utils.quote-omission,
    _utils.i18n,
    _utils._pkg.glossarium,
    _utils._pkg.glossarium.gls,
    _utils._pkg.glossarium.glspl,
    _core.doc,
    _core.kinds.report,
    _core.kinds.thesis.with(kind: _core.kinds.kinds.thesis-bachelor),
    _core.kinds.thesis.with(kind: _core.kinds.kinds.thesis-master),
  )
}
