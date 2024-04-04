#let is-boundary(value) = {
  value.len() == 0 or value.starts-with(" ")
}

#let eat(value, token) = {
  if value.starts-with(token) {
    let rest = value.trim(at: start, repeat: false, token)
    let part = value.len() - rest.len()
    (value.slice(0, part), value.slice(part))
  } else {
    (none, value)
  }
}

#let eat-any(value, tokens) = {
  for curr in tokens {
    let (token, rest) = eat(value, curr)
    if token != none {
      return (token, rest)
    }
  }

  (none, value)
}

