#import "/src/utils.typ" as _utils

#let make-table-of-contents(
  appendix-marker: none,
  _fonts: (:),
) = {
  show outline.entry: it => {
    if it.level == 1 {
      v(18pt, weak: true)
      strong({
        let is-appendix = (
          appendix-marker != none
            and query(appendix-marker).len() != 0
            and false
            // BUG: somehow only one appendix marker is found despite `doc` placing two
            // and _utils.is-within-markers(it.element, appendix-marker)
        )

        let body = if is-appendix and it.element.numbering != none {
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

  outline(depth: 3, indent: auto)
}
