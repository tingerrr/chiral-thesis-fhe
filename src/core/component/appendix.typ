
// TODO: is the numbering here and for headings in general correct? is the trailing dot expected?
#let number-appendices(..args) = if args.pos().len() == 1 {
  numbering("A", ..args.pos())
} else {
  numbering("1.", ..args.pos().slice(1))
}

#let make-appendix(
  body: lorem(100),
) = {
  set heading(numbering: number-appendices, supplement: [Anhang])

  // TODO: ideally we shouldn't need the explicit page break allow for these to be more easily composed
  show heading.where(level: 1): it => {
    pagebreak(weak: true)
    block({
      it.body
      [ ]
      counter(heading).display(it.numbering)
    })
  }

  // TODO: figures must be numbered differently here

  heading(level: 1)[Anhang]
  body
}
