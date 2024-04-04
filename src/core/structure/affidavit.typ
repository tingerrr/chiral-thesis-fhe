#import "/src/core/authors.typ" as _authors
#import "/src/core/kinds.typ" as _kinds

#import "/src/utils.typ" as _utils

#let make-affidavit(
	title: "Mustertitel",
	author: "Max, Mustermann",
  date: datetime.today(),
	body: auto,
	kind: _kinds.report,
) = {
  _authors.assert-author-valid(author)
  _kinds.assert-kind-valid(kind)

  author = _authors.prepare-author(author)

  set heading(numbering: none, outlined: true, offset: 0)

	if body == auto {
    heading(level: 1)[Eigenständigkeitserklärung]
    [
      Ich, #_authors.format-author(author, titles: false, email: false), versichere hiermit, dass ich die vorliegende #kind.name mit dem Titel
      #align(center, emph(title))
      selbstständig und nur unter Verwendung der angegebenen Quellen und Hilfsmittel angefertigt habe.
    ]
  
    align(right)[
      Erfurt, #_utils.format-date(date)
    ]
    _authors.format-author(author, titles: false, email: false)
  } else if type(independence) == content {
    heading(level: 1)[Eigenständigkeitserklärung]
    independence
  }
}
