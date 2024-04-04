#import "/src/utils.typ" as _utils

// TODO: better appendix detection, use a metadata marker
#let make-table-of-contents() = {
  show outline.entry: it => {
    // do not indent appendices
    if it.level == 1 or it.element.numbering == _utils.number-appendices {
      v(18pt, weak: true)
      strong({
        link(it.element.location(), text(font: "Latin Modern Sans", it.body))
        h(1fr)
        it.page
      })
    } else {
      link(it.element.location(), it.body)
      [ ]
      box(width: 1fr, repeat("  .  "))
      [ ]
      box(
        width: measure[999].width,
        align(right, it.page),
      )
    }
  }

  show outline: set heading(numbering: none, outlined: false, offset: 0)

  outline(depth: 3, indent: auto)

  // BUG: removing this seems to break the introspection for the page number of the next heading inside the toc
  pagebreak(weak: true)
}
