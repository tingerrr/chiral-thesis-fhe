#let (pseudocode, pseudocode-list, no-number, with-line-label, indent, line-label) = {
  import "/src/packages.typ" as _pkg
  import "/src/utils.typ" as _utils

  (
    _pkg.lovelace.pseudocode.with(),
    _pkg.lovelace.pseudocode-list.with(
      line-number-supplement: _utils.i18n(de: [Zeile], en: [Line]),
      booktabs: true,
      booktabs-stroke: 1pt + black,
      stroke: 0.25pt + gray,
    ),
    _pkg.lovelace.no-number.with(),
    _pkg.lovelace.with-line-label.with(),
    _pkg.lovelace.indent.with(),
    _pkg.lovelace.line-label.with(),
  )
}
