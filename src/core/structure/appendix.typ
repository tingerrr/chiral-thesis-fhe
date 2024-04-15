#import "/src/utils.typ" as _utils

#let make-appendix(
	body: lorem(100),
) = {
  set heading(numbering: _utils.number-appendices, supplement: [Anhang])

	// TODO: figures must be numbered differently here

  heading(level: 1)[Anhang]
  body
}
