#import "/src/utils.typ" as _utils

#let make-table-of-contents(
  appendix-marker: none,
  _outline-state: _utils.state.outline,
  _appendix-state: _utils.state.appendix,
  _fonts: (:),
) = {
  show outline.entry: it => {
    if it.level == 1 {
      v(18pt, weak: true)
      strong({
        let body = if _appendix-state.at(it.element.location()) and it.element.numbering != none {
          it.element.body
          [ ]
          numbering(it.element.numbering, ..counter(it.element.func()).at(it.element.location()))
        } else {
          it.body
        }
        link(it.element.location(), text(font: _fonts.sans, body))
        h(1fr)
        it.page
      })
    } else {
      it
    }
  }

  show outline: set heading(numbering: none, outlined: false, offset: 0)

  _outline-state.update(true)
  outline(depth: 3, indent: auto)
  _outline-state.update(false)
}
