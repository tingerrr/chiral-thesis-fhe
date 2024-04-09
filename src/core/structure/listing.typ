#let make-listing(
  target: image,
  title: auto,
  force-empty: false,
) = context {
  if force-empty or query(figure.where(kind: target)).filter(f => f.caption != none).len() != 0 {
    show outline: set heading(numbering: none, outlined: true, offset: 0)

    outline(target: figure.where(kind: target), title: title)
    // pagebreak(weak: true)
  }
}
