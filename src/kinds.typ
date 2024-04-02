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
  author: "Musterstudent, Max",
  field: [Fachbereich],
  date: datetime.today(),
) = {
  (
    kind: kinds.report,

    title: title,
    author: author,
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
    author: author,
    field: field,

    date: date,

    supervisors: supervisors,
  )
}

#let is-thesis(kind) = kind.key.starts-with("thesis-")
