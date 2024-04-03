#import "packages.typ" as _pkg

#let _std = (
  link: link,
)

// TODO: improve this to properly parse Dipl-Ing. and such
#let parse-title(value) = {
  assert.eq(
    type(value), str,
    message: _pkg.oxifmt.strfmt("`value` must be a string, was {}", type(value))
  )

  value = value.trim().split(" ").filter(frag => frag.len() != 0)

  if value.len() == 0 {
    panic("title cannot be empty")
  }

  let (first, ..rest) = value

  if first not in ("Dr.", "Prof.", "B.Sc.", "M.Sc.") {
    panic("only professor, doctor, bachelor and master's titles are currently allowed")
  }

  if first == "Dr." {
    if rest.len() != 2 or rest.at(1) != "nat." {
      panic("only doctor ... naturalum title suffixes are currently allowed")
    }
  } else {
    if rest.len() != 0 {
      panic("only doctor titles currently allow suffixes")
    }
  }

  (
    main: first,
    suffixes: rest,
  )
}

#let parse-name(value) = {
  assert.eq(
    type(value), str,
    message: _pkg.oxifmt.strfmt("`value` must be a string, was {}", type(value))
  )

  value = value.trim().split(" ").filter(frag => frag.len() != 0)

  if value.len() == 0 {
    panic("name cannot be empty")
  }

  // if there's a comma it designates "last, first" style naming
  let part = none
  for (idx, frag) in value.enumerate() {
    if frag.ends-with(",") {
      if part != none {
        panic("a name may only contain one comma")
      }
      part = idx
    }
  }

  // remove the comma for the validation
  if part != none {
    value.at(part) = value.at(part).trim(",", repeat: false)
    part = part + 1
  }

  // validate names
  // NOTE: using \w is too permissive, but this is not really an issue in most cases
  if not value.all(frag => frag.match(regex("^([\\w'\\-]+|[\\w]\\.)$")) != none) {
    panic("name contained invalid character")
  }

  let (first, last) = if part != none {
    if value.len() == 1 {
      panic("first name may not be empty")
    } else {
      (value.slice(part), value.slice(0, part))
    }
  } else {
    if value.len() == 1 {
      ((value.first(),), ())
    } else {
      (value.slice(0, -1), (value.last(),))
    }
  }

  (
    first: first,
    last: last,
  )
}

#let parse-author(value) = {
  assert.eq(
    type(value), str,
    message: _pkg.oxifmt.strfmt("`value` must be a string, was {}", type(value))
  )

  value = value.trim().split(" ").filter(frag => frag.len() != 0)

  if value.len() == 0 {
    panic("author cannot be empty")
  }

  // TODO: this will fail on abbreviated names
  // we try finding the last item that is a title
  let part = none
  for (idx, frag) in value.enumerate() {
    if part == none {
      if frag.ends-with(".") {
        part = idx
      }
    } else {
      if not frag.ends-with(".") {
        part = idx
        break
      }
    }
  }

  let titles = ()
  if part != none {
    assert.ne(part, value.len() - 1, message: "author must contain name")
    titles = value.slice(0, part)
    value = value.slice(part)
  }

  let email = if value.last().starts-with("<") and value.last().ends-with(">") {
    assert(value.len() != 1, message: "author must contain name")
    value
      .remove(value.len() - 1)
      .trim("<", repeat: false, at: start)
      .trim(">", repeat: false, at: end)
  }

  (
    titles: titles.map(parse-title),
    name: parse-name(value.join(" ")),
    email: email,
  )
}

#let format-title(title, suffixes: true) = {
  assert.eq(
    type(title), dictionary,
    message: _pkg.oxifmt.strfmt("`title` must be a title dictionary, was {}", type(title)),
  )
  assert.eq(
    title.keys(), ("main", "suffixes"),
    message: _pkg.oxifmt.strfmt(
      "`title` must contain `main` and `suffixes`, contained {}",
      title.keys(),
    ),
  )

  title.main
  if suffixes and title.suffixes.len() != 0 {
    " "
    title.suffixes.join(" ")
  }
}

#let format-name(name, abbreviate: false, last-first: false) = {
  assert.eq(
    type(name), dictionary,
    message: _pkg.oxifmt.strfmt("`name` must be a name dictionary, was {}", type(name)),
  )
  assert.eq(
    name.keys(), ("first", "last"),
    message: _pkg.oxifmt.strfmt(
      "`name` must contain `first` and `last`, contained {}",
      name.keys(),
    ),
  )

  let first = if abbreviate {
    name.first.map(n => if n.ends-with(".") { n } else { n.clusters().first() + "." }).join(" ")
  } else {
    name.first.join(" ")
  }

  let last = name.last.join(" ")

  if last-first {
    if name.last.len() != 0 {
      last
      ", "
    }
    first
  } else {
    first
    if name.last.len() != 0 {
      " "
      last
    }
  }
}

#let format-author(
  author,
  titles: true,
  title-suffixes: true,
  abbreviate: false,
  email: true,
  link: false,
) = {
  assert.eq(
    type(author), dictionary,
    message: _pkg.oxifmt.strfmt("`author` must be an author dictionary, was {}", type(author)),
  )
  assert.eq(
    author.keys(), ("titles", "name", "email"),
    message: _pkg.oxifmt.strfmt(
      "`author` must contain `titles`, `name` and `email`, contained {}",
      author.keys(),
    ),
  )

  if titles {
    for title in author.titles {
      format-title(title, suffixes: title-suffixes)
      " "
    }
  }

  format-name(author.name, abbreviate: abbreviate)

  if email and author.email != none {
    // this will convert the output into content
    if link {
      " "
      (_std.link)("mailto:" + author.email, author.email)
    } else {
      " <"
      author.email
      ">"
    }
  }
}
