#let make-listings(
  listings: (:),
  force-empty: false,
) = context {
  let filtered = if force-empty {
    listings
  } else {
    listings.filter(l => {
      query(figure.where(kind: l.target)).filter(f => f.caption != none).len() != 0
    })
  }

  show outline: set heading(numbering: none, outlined: true, offset: 0)

  filtered.map(listing => {
    outline(target: figure.where(kind: listing.target), title: listing.title)
  }).join(pagebreak(weak: true))
}
