#import "utils/token.typ"
#import "utils/assert.typ"

#let _std = (numbering: numbering)

#let sentinel-or(sentinel, value, default) = if value == sentinel {
  value
} else {
  default()
}

#let none-or = sentinel-or.with(none)
#let auto-or = sentinel-or.with(auto)

#let todo(..args) = {
  assert.std.eq(args.named().len(), 0, "`todo` expects no named args")

  let pos = args.pos()

  let (data, body) = if pos.len() == 1 {
    (pos.first(), pos.first())
  } else if pos.len() == 2 {
    pos
  } else {
    panic("`todo` expects 1 or 2 positional args")
  }

  [#metadata(data) <todo>]
  text(fill: red, body)
}

#let chapter = heading.with(level: 1)

#let chapter-relative-numbering(numbering, ..args) = {
  (_std.numbering)(numbering, counter(heading).get().first(), ..args)
}

// TODO: is the numbering here and for headings in general correct? is the trailing dot expected?
#let number-appendices(..args) = if args.pos().len() == 1 {
  none
} else if args.pos().len() == 2 {
  numbering("A", ..args.pos().slice(1))
} else {
  numbering("1.", ..args.pos().slice(2))
}

#let date-time-en-to-de = (
  Jan: "Jan",
  Feb: "Feb",
  Mar: "Mär",
  Jun: "Jun",
  Jul: "Jul",
  Aug: "Aug",
  Sep: "Sep",
  Oct: "Okt",
  Nov: "Nov",
  Dec: "Dez",

  January: "Januar",
  February: "Februar",
  March: "März",
  May: "Mai",
  June: "Juni",
  July: "Juli",
  August: "August",
  September: "September",
  October: "Oktober",
  November: "November",
  December: "Dezember",

  Mon: "Mo",
  Tue: "Di",
  Wed: "Mi",
  Thu: "Do",
  Fri: "Fr",
  Sat: "Sa",
  Sun: "So",

  Monday: "Montag",
  Tuesday: "Dienstag",
  Wednesday: "Mittwoch",
  Thursday: "Donnerstag",
  Friday: "Freitag",
  Saturday: "Samstag",
  Sunday: "Sontag",
)

#let format-date(date, format: "[day].[month].[year]") = {
  date
    .display(format)
    .replace(regex("[a-zA-Z]+"), m => date-time-en-to-de.at(m.text))
}
