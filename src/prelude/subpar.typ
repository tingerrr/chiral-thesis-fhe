#let (super, grid) = {
  import "/src/packages.typ" as _pkg
  import "/src/utils.typ" as _utils

  let subpar-args = (
    numbering: n => _utils.chapter-relative-numbering("1-1", n),
    numbering-sub-ref: (n, m) => _utils.chapter-relative-numbering("1-1a", n, m),
    show-sub-caption: (_, it) => emph(it),
  )

  (
    _pkg.subpar.super.with(..subpar-args),
    _pkg.subpar.grid.with(..subpar-args),
  )
}
