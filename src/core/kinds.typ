#import "/src/core/authors.typ" as _authors

#let kinds = (
  report: (
    key: "report",
    name: "Belegarbeit",
  ),
  thesis-bachelor: (
    key: "thesis-bachelor",
    name: "Bachelorarbeit",
  ),
  thesis-master: (
    key: "thesis-master",
    name: "Masterarbeit"
  ),
)

#let report(
  title: [Mustertitel],
  subtitle: none,
  author: "Musterstudent, Max",
  field: [Fachbereich],
  date: datetime(year: 1970, month: 01, day: 01),
) = {
  (
    kind: kinds.report,
    id: none,

    title: title,
    subtitle: subtitle,
    author: _authors.prepare-author(author),
    field: field,

    date: date,
    supervisors: (),
  )
}

#let thesis(
  kind: none,
  id: [ID],

  title: [Mustertitel],
  subtitle: none,
  author: "Musterstudent, Max",
  field: [Fachbereich],
  date: datetime(year: 1970, month: 01, day: 01),

  supervisors: (
    "Prof. Dr. Max Mustermann",
    "Prof. Dr. Maxine Musterfrau",
  ),
) = {
  (
    kind: kind,
    id: id,

    title: title,
    subtitle: subtitle,
    author: _authors.prepare-author(author),
    field: field,

    date: date,

    supervisors: supervisors.map(_authors.prepare-author),
  )
}

// TODO: error handling
#let is-thesis(kind) = kind.key.starts-with("thesis-")

#let assert-kind-valid(kind) = {
  assert.eq(type(kind), dictionary)
  // ...
}
