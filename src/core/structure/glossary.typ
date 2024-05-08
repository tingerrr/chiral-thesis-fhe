#import "/src/utils.typ" as _utils

#let make-glossary(
  entries: (:),
  _fonts: (:),
) = {
  // TODO: perhaps apply the styles only for some parts of the docs in core so those require no resets

  // reverse the figure styles
  show figure.caption: emph
  show figure.caption: set text(fill: black, font: _fonts.serif)

  heading(level: 1)[Glossar]
  _utils._pkg.glossarium.print-glossary(entries, show-all: true)
}
