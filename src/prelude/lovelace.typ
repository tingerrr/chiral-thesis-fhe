#let (pseudocode, pseudocode-list, no-number, with-line-label, indent, line-label) = {
  import "/src/_pkgs.typ"
  import "/src/utils.typ" as _utils

  (
    _pkgs.lovelace.pseudocode.with(),
    _pkgs.lovelace.pseudocode-list.with(
      line-number-supplement: _utils.i18n(de: [Zeile], en: [Line]),
      booktabs: true,
      booktabs-stroke: 1pt + black,
      stroke: 0.25pt + gray,
    ),
    _pkgs.lovelace.no-number.with(),
    _pkgs.lovelace.with-line-label.with(),
    _pkgs.lovelace.indent.with(),
    _pkgs.lovelace.line-label.with(),
  )
}
