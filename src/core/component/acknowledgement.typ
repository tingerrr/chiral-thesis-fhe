#let make-acknowledgement(
  body: lorem(100),
) = {
  heading(level: 1)[Danksagung]
  set par(justify: true)
  body
}
