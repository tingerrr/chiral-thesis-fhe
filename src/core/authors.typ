#import "/src/packages.typ" as _pkg
#import "/src/utils.typ" as _utils

#let _std = (
  link: link,
)

#let _eat-title(value) = {
  let rest = value.trim(at: start)

  let (main, rest) = _utils.token.eat-any(rest, (
    "Dr.", "Prof.", regex("Dipl-\\w+\\."), "M.", "B.",
  ))

  if main == none {
    return (err: _pkg.oxifmt.strfmt("unknown tilte at: `{}`", rest))
  }

  if not _utils.token.is-boundary(rest) {
    return (err: _pkg.oxifmt.strfmt("unexpected input after title at: `{}`", rest))
  }

  if main in ("Prof.", "Dr.", "M.", "B.") {
    if main == "Prof." {
      ((main: main, suffix: none), rest)
    } else if main == "Dr." {
      let (suffix, rest) = _utils.token.eat(rest.trim(at: start), regex("\\w+\\. *nat\\."))
      if suffix != none {
        if not _utils.token.is-boundary(rest) {
          return (err: _pkg.oxifmt.strfmt("unexpected after doctor suffix at: `{}`", rest))
        }
      }

      ((main: main, suffix: suffix), rest)
    } else {
      let (suffix, rest) = _utils.token.eat(rest.trim(at: start), "Sc.")

      if suffix == none {
        return (err: _pkg.oxifmt.strfmt(
          "unknown {} suffix at `{}`",
          if main == "M." { "masters" } else { "bachelors" },
          rest,
        ))
      }

      ((main: main, suffix: suffix), rest)
    }
  } else {
    if not _utils.token.is-boundary(rest) {
      return (err: _pkg.oxifmt.strfmt("unexpected input at: `{}`", rest))
    }

    ((main: main, suffix: none), rest)
  }
}

#let parse-title(value) = {
  assert.eq(
    type(value), str,
    message: _pkg.oxifmt.strfmt("`value` must be a string, was {}", type(value))
  )

  let res = _eat-title(value)
  if type(res) == dictionary {
    panic(res.err)
  }

  let (title, rest) = res

  rest = rest.trim(at: start)
  if rest.len() != 0 {
    panic(_pkg.oxifmt.strfmt("unexpected input at `{}`", rest))
  }

  title
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
    panic(_pkg.oxifmt.strfmt("name contained invalid character: `{}`", value.join(" ")))
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

  value = value.trim()

  let titles = ()
  while true {
    let res = _eat-title(value)
    if type(res) == dictionary {
      break
    } else {
      let (title, rest) = res
      titles.push(title)
      value = rest
    }
  }

  value = value.trim().split(" ").filter(frag => frag.len() != 0)

  if value.len() == 0 {
    panic("author cannot be empty")
  }

  let email = if value.last().starts-with("<") and value.last().ends-with(">") {
    assert(value.len() != 1, message: "author must contain name")
    value
      .remove(value.len() - 1)
      .trim("<", repeat: false, at: start)
      .trim(">", repeat: false, at: end)
  }

  (
    titles: titles,
    name: parse-name(value.join(" ")),
    email: email,
  )
}

#let format-title(title, suffix: true) = {
  assert.eq(
    type(title), dictionary,
    message: _pkg.oxifmt.strfmt("`title` must be a title dictionary, was {}", type(title)),
  )
  assert.eq(
    title.keys(), ("main", "suffix"),
    message: _pkg.oxifmt.strfmt(
      "`title` must contain `main` and `suffix`, contained {}",
      title.keys(),
    ),
  )

  title.main
  if suffix and title.suffix != none {
    " "
    title.suffix
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
  title-suffix: true,
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
      format-title(title, suffix: title-suffix)
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

#let prepare-author(author) = {
  if type(author) == str {
    parse-author(author)
  } else if type(author) == dictionary {
    // TODO: validate dictionary
    author
  } else {
    panic("only string and author dictionary are allowed as author")
  }
}

// TODO: check dict keys and values
#let assert-author-valid(author) = {
  assert(type(author) in (str, dictionary))
}
