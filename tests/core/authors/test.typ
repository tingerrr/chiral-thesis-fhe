#import "/src/lib.typ" as ctf

//
// parsing
//
#import ctf.authors: parse-title, parse-name, parse-author

// title
#let prof = (
  main: "Prof.",
  suffixes: (),
)
#let dr = (
  rer-nat: (
    main: "Dr.",
    suffixes: ("rer.", "nat."),
  ),
  sc-nat: (
    main: "Dr.",
    suffixes: ("sc.", "nat."),
  ),
)
#assert.eq(parse-title("Prof."), prof)
#assert.eq(parse-title("Dr. rer. nat."), dr.rer-nat)
#assert.eq(parse-title("Dr. sc. nat."), dr.sc-nat)

// single name
#assert.eq(parse-name("Frank"), (first: ("Frank",), last: ()))

// first and last
#let turing = (
  first: ("Alan",),
  last: ("Turing",),
)
#assert.eq(parse-name("Alan Turing"), turing)
#assert.eq(parse-name("Turing, Alan"), turing)

// first, second and last single
#let dumbledore = (
  first: ("Albus", "Percival", "Wulfric", "Brian"),
  last: ("Dumbledore",),
)
#assert.eq(parse-name("Albus Percival Wulfric Brian Dumbledore"), dumbledore)
#assert.eq(parse-name("Dumbledore, Albus Percival Wulfric Brian"), dumbledore)

// last mutliple
#let scott-moncrieff = (
  first: ("Charles", "Kenneth"),
  last: ("Scott", "Moncrieff"),
)
#let lloyd-webber = (
  first: ("Andrew",),
  last: ("Lloyd", "Webber",),
)
#assert.eq(parse-name("Scott Moncrieff, Charles Kenneth"), scott-moncrieff)
#assert.eq(parse-name("Lloyd Webber, Andrew"), lloyd-webber)

// abbreviations
#let knuth = (
  first: ("Donald", "E."),
  last: ("Knuth",),
)
#assert.eq(parse-name("Donald E. Knuth"), knuth)
#assert.eq(parse-name("Knuth, Donald E."), knuth)

// author
#let tingerrr = (
  titles: (
    (
      main: "B.Sc.",
      suffixes: (),
    ),
  ),
  name: (
    first: ("tingerrr",),
    last: (),
  ),
  email: "me@tinger.dev",
)
#assert.eq(parse-author("B.Sc. tingerrr <me@tinger.dev>"), tingerrr)

//
// formatting
//
#import ctf.authors: format-title, format-name, format-author

// title
#assert.eq(format-title(prof), "Prof.")
#assert.eq(format-title(dr.rer-nat), "Dr. rer. nat.")
#assert.eq(format-title(dr.sc-nat), "Dr. sc. nat.")

// name
#assert.eq(format-name(turing), "Alan Turing")
#assert.eq(format-name(knuth), "Donald E. Knuth")

// comma format
#assert.eq(format-name(dumbledore, last-first: true), "Dumbledore, Albus Percival Wulfric Brian")

// name abbreviation
#assert.eq(format-name(scott-moncrieff, abbreviate: true), "C. K. Scott Moncrieff")
#assert.eq(format-name(knuth, abbreviate: true), "D. E. Knuth")

// author
#assert.eq(format-author(tingerrr, link: false), "B.Sc. tingerrr <me@tinger.dev>")