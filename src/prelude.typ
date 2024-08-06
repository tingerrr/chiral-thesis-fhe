// NOTE: these are largely used for styling configuration which will be done
// with set rules once custom types exist
#import "prelude/subpar.typ"
#import "prelude/lovelace.typ"

#let (
  // helper functions
  chapter,
  q,
  i18n,

  // glossarium re-exports
  glossarium,
  gls,
  glspl,

  // lovelace re-exports
  algorithm,
  line-label,

  // template
  doc,

  // kinds
  report,
  bachelors-thesis,
  masters-thesis,
) = {
  import "core.typ" as _core
  import "packages.typ" as _pkg
  import "utils.typ" as _utils

  (
    _utils.chapter,
    _utils.quote-omission,
    _utils.i18n,

    _pkg.glossarium,
    _pkg.glossarium.gls,
    _pkg.glossarium.glspl,

    lovelace.pseudocode-list,
    lovelace.line-label,

    _core.doc,
    _core.kinds.report,
    _core.kinds.thesis.with(kind: _core.kinds.kinds.thesis-bachelor),
    _core.kinds.thesis.with(kind: _core.kinds.kinds.thesis-master),
  )
}
