#import "/src/packages.typ" as _pkg

#import "utils/token.typ"
#import "utils/assert.typ"
#import "utils/state.typ"

#let chapter(to: none, label: none, ..args) = {
  pagebreak(weak: true, to: to)
  let chap = heading(level: 1, supplement: [Kapitel], ..args)
  if label == none {
    chap
  } else {
    [#chap #label]
  }
}

#let smart-caption(short, long, _state: state.outline) = context if _state.get() {
  short
} else {
  long
}

#let i18n(de: none, en: none) = context if text.lang == "de" { de } else { en }

#let sentinel-or(sentinel, value, default) = if value == sentinel {
  value
} else {
  default()
}

#let none-or = sentinel-or.with(none)
#let auto-or = sentinel-or.with(auto)

#let marker(name) = if type(name) == str {
  [#metadata(())#label(name)]
} else if type(name) == label {
  [#metadata(())#name]
} else {
  panic(_pkg.oxifmt.strfmt("Can't use `{}` as a marker", name))
}

#let pagebreak-marker = (
  start: " __ctf:break:start",
  end: " __ctf:break:end",
)

// credit: https://github.com/typst/typst/issues/2722#issuecomment-2481508318
#let is-blank-page() = {
  let page-num = here().page()
  let markers = selector.or(
    label(pagebreak-marker.start),
    label(pagebreak-marker.end),
  )
  query(markers).chunks(2).any(((start, end)) => {
    start.location().page() < page-num and page-num < end.location().page()
  })
}

// BUG: this and its usages can't respect appendix numbering beacuse the pattern doesn't react to the styles to synthesize it's pattern
#let chapter-relative-numbering(numbering, ..args) = {
  std.numbering(numbering, counter(heading).get().first(), ..args)
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
