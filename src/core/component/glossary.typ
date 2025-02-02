#import "/src/ctx.typ" as _ctx
#import "/src/_pkgs.typ"

#let glossary(entries: (:), ctx: _ctx.default) = {
  // TODO: perhaps apply the styles only for some parts of the docs in core so those require no resets

  // reverse the figure styles
  show figure.caption: emph
  show figure.caption: set text(fill: black, font: ctx.fonts.serif)

  heading(level: 1)[Glossar]
  _pkgs.glossarium.print-glossary(entries, show-all: true)
}
