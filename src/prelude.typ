// NOTE(tinger): These are re-exports in order to behave like the original
// packages but with the adjusted defaults. This will be replaced with set rules
// once custom types exist.
#import "prelude/subpar.typ"
#import "prelude/lovelace.typ"

#let (
  // helper functions
  chapter,
  i18n,
  smartcap,
  todo,

  // glossarium re-exports
  glossarium,
  gls,
  glspl,

  // lovelace re-exports
  lovelace,
  algorithm,
  line-label,

  // template
  doc,

  // kinds
  report,
  bachelors-thesis,
  masters-thesis,
) = {
  import "_doc.typ"
  import "_pkgs.typ"
  import "core.typ" as _core
  import "ctx.typ" as _ctx
  import "utils.typ" as _utils

  (
    _utils.chapter,
    _utils.i18n,
    _ctx.smart-caption,
    _utils.todo,

    _pkgs.glossarium,
    _pkgs.glossarium.gls,
    _pkgs.glossarium.glspl,

    lovelace,
    lovelace.pseudocode-list,
    lovelace.line-label,

    _doc.doc,
    _core.kinds.report,
    _core.kinds.thesis.with(kind: _core.kinds.kinds.thesis-bachelor),
    _core.kinds.thesis.with(kind: _core.kinds.kinds.thesis-master),
  )
}
