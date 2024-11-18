#import "component/abstract.typ": abstract, abstracts
#import "component/acknowledgement.typ": acknowledgement
#import "component/appendix.typ": appendix, appendices
#import "component/affidavit.typ": affidavit
#import "component/glossary.typ": glossary
#import "component/table-of-contents.typ": table-of-contents
#import "component/title-page.typ": title-page
#import "component/outline.typ": outline, outlines

#let _abstracts = abstracts
#let _acknowledgement = acknowledgement
#let _appendices = appendices
#let _affidavit = affidavit
#let _glossary = glossary
#let _outlines = outlines

#import "/src/ctx.typ" as _ctx
#import "/src/core/kinds.typ" as _kinds
#import "/src/core/styles.typ" as _styles

/// Construct the default prelude.
#let prelude(
  kind: (:),
  abstracts: (
    (title: "Kurzfassung", body: lorem(100)),
    (title: "Abstract", body: lorem(100)),
  ),
  ctx: _ctx.default,
) = {
  set page(numbering: none)

  title-page(kind: kind, ctx: ctx)

  if type(abstracts) == content {
    abstracts
  } else {
    _abstracts(abstracts: abstracts)
  }
}

#let front-matter(
  kind: (:),
  acknowledgement: none,
  affidavit: auto,
  affidavit-force: false,
  outlines: none,
  outlines-force-empty: false,
  ctx: _ctx.default,
) = {
  set page(numbering: "I")
  counter(page).update(1)

  if acknowledgement != none {
    if type(acknowledgement) == content {
      acknowledgement
    } else {
      _acknowledgement(body: acknowledgement, ctx: ctx)
    }
  }

  if affidavit != none {
    if type(affidavit) == content {
      affidavit
    } else if (affidavit-force or _kinds.is-thesis(kind.kind)) and affidavit == auto {
      _affidavit(kind: kind, body: affidavit, ctx: ctx)
    }
  }

  table-of-contents(ctx: ctx)

  if outlines != none {
    if type(outlines) == content {
      outlines
    } else {
      _outlines(outlines: outlines, force-empty: outlines-force-empty, ctx: ctx)
    }
  }

  _ctx.marker(ctx.labels.front-matter-anchor)
}

/// Construct the default main content body.
#let main-content(
  kind: (:),
  draft: true,
  body,
  ctx: _ctx.default,
) = {
  set page(numbering: "1")
  counter(page).update(1)

  show: _styles.content(draft: draft, ctx: ctx)
  body
}

/// Construct the default back matter.
#let back-matter(
  kind: (:),
  outlines: none,
  outlines-force-empty: false,
  appendices: none,
  glossary: none,
  bibliography: none,
  acknowledgement: none,
  affidavit: auto,
  affidavit-force: false,
  ctx: _ctx.default,
) = {
  set page(numbering: "I")
  context counter(page).update(counter(page).at(ctx.labels.front-matter-anchor).first() + 1)

  if outlines != none {
    if type(outlines) == content {
      outlines
    } else {
      _outlines(outlines: outlines, force-empty: outlines-force-empty, ctx: ctx)
    }
  }

  if appendices != none {
    if type(appendices) == content {
      appendices
    } else {
      _appendices(appendices: appendices, ctx: ctx)
    }
  }

  if glossary != none {
    if type(glossary) == content {
      glossary
    } else {
      _glossary(entries: glossary, ctx: ctx)
    }
  }

  bibliography

  if acknowledgement != none {
    if type(acknowledgement) == content {
      acknowledgement
    } else {
      _acknowledgement(body: acknowledgement, ctx: ctx)
    }
  }

  if affidavit != none {
    if type(affidavit) == content {
      affidavit
    } else if (affidavit-force or _kinds.is-thesis(kind.kind)) and affidavit == auto {
      _affidavit(kind: kind, body: affidavit, ctx: ctx)
    }
  }
}
