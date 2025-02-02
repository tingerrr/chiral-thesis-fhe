#import "/src/core/authors.typ" as _authors
#import "/src/ctx.typ" as _ctx
#import "/src/utils.typ" as _utils

#let affidavit(
  kind: (:),
  body: auto,
  ctx: _ctx.default,
) = {
  let author = _authors.prepare-author(kind.author)

  set heading(numbering: none, outlined: true, offset: 0)

  heading(level: 1)[Eigenständigkeitserklärung]
  [
    Ich, #_authors.format-author(author, titles: false, email: false), versichere hiermit, dass ich die vorliegende #kind.kind.name mit dem Titel
    #align(center, emph(kind.title))
    selbstständig und nur unter Verwendung der angegebenen Quellen und Hilfsmittel angefertigt habe.
  ]

  align(right)[
    Erfurt, #_utils.format-date(kind.date)
  ]
  _authors.format-author(author, titles: false, email: false)
}
