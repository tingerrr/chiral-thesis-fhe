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

#let _prepare-author(author) = {
  if type(author) == str {
    import "authors.typ"
    authors.parse-author(author)
  } else if type(author) == dictionary {
    author
  } else {
    panic("only string and author dictionary are allowed as author")
  }
}

#let report(
  title: [Mustertitel],
  author: "Musterstudent, Max",
  field: [Fachbereich],
  date: datetime.today(),
) = {
  (
    kind: kinds.report,

    title: title,
    author: _prepare-author(author),
    field: field,

    date: date,
  )
}

#let thesis(
  kind: none,
  id: [ID],

  title: [Mustertitel],
  author: "Musterstudent, Max",
  field: [Fachbereich],
  date: datetime.today(),

  supervisors: (
    "Prof. Dr. Max Mustermann",
    "Prof. Dr. Maxine Musterfrau",
  ),
) = {
  (
    kind: kind,
    id: id,

    title: title,
    author: _prepare-author(author),
    field: field,

    date: date,

    supervisors: supervisors.map(_prepare-author),
  )
}

#let is-thesis(kind) = kind.key.starts-with("thesis-")
