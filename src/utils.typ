#import "/src/ctx.typ" as _ctx
#import "/src/packages.typ" as _pkg

#import "utils/token.typ"
#import "utils/assert.typ"

#let chapter(to: none, label: none, ..args) = {
  pagebreak(weak: true, to: to)
  let chap = heading(level: 1, supplement: [Kapitel], ..args)
  if label == none {
    chap
  } else {
    [#chap #label]
  }
}

#let i18n(de: none, en: none) = context if text.lang == "de" { de } else { en }

#let sentinel-or(sentinel, value, default) = if value == sentinel {
  value
} else {
  default()
}

#let none-or = sentinel-or.with(none)
#let auto-or = sentinel-or.with(auto)

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
