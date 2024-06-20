#import "/src/packages.typ" as _pkg

#import "utils/token.typ"
#import "utils/assert.typ"

#let _std = (numbering: numbering)

#let sentinel-or(sentinel, value, default) = if value == sentinel {
  value
} else {
  default()
}

#let marker(name) = if type(name) == str {
  [#metadata(())#label(name)]
} else if type(name) == label {
  [#metadata(())#name]
} else {
  panic(_pkg.oxifmt.strfmt("Can't use `{}` as a marker", name))
}

#let none-or = sentinel-or.with(none)
#let auto-or = sentinel-or.with(auto)

#let is-within-markers(
  loc,
  marker,
) = {
  assert.std(type(loc) in (content, location, label, selector), message: _pkg.oxifmt.strfmt(
    "`loc` must be locatable, was `{}`",
    type(loc),
  ))

  if type(loc) == content {
    loc = loc.location().position()
  } else if type(loc) != location {
    loc = locate(loc).position()
  }

  assert.std.eq(type(marker), label, message: _pkg.oxifmt.strfmt(
    "marker must be `label`, was `{}`",
    type(marker)
  ))

  let markers = query(marker)

  assert.std.eq(markers.len(), 2, message: _pkg.oxifmt.strfmt(
    "found {} `{}` markers, expected 2", markers.len(), marker
  ))

  let (a, b) = markers.map(m => m.location().position())

  // before first
  if loc.page < a.page { return false }
  if loc.page == a.page and loc.y < a.y { return false }

  // after last
  if b.page < loc.page { return false }
  if b.page == loc.page and b.y < loc.y { return false }

  true
}

// BUG: this and its usages can't respect appendix numbering beacuse the pattern doesn't react to the styles to synthesize it's pattern
#let chapter-relative-numbering(numbering, ..args) = {
  (_std.numbering)(numbering, counter(heading).get().first(), ..args)
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
