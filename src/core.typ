#import "core/authors.typ"
#import "core/kinds.typ"
#import "core/component.typ"
#import "core/styles.typ"

#import "/src/ctx.typ" as _ctx
#import "/src/utils.typ" as _utils

// TODO: arg validation
// TODO: provide good defaults
#let doc(
  kind: (:),
  draft: true,
  abstracts: none,
  bibliography: none,
  outlines: (),
  outlines-position: start,
  outlines-force-empty: false,
  glossary: none,
  appendices: none,
  acknowledgement: none,
  acknowledgement-position: end,
  affidavit: auto,
  affidavit-position: end,
  affidavit-force: false,
  ctx: _ctx.default,
) = body => {
  show: styles.document(draft: draft, ctx: ctx)

  component.prelude(kind: kind, abstracts: abstracts, ctx: ctx)

  show: styles.post-abstract(
    faculty: kind.field,
    ctx: ctx,
  )

  component.front-matter(
    kind: kind,
    acknowledgement: if acknowledgement-position == start { acknowledgement },
    affidavit: if affidavit-position == start { affidavit },
    affidavit-force: affidavit-force,
    outlines: if outlines-position == start { outlines },
    outlines-force-empty: outlines-force-empty,
    ctx: ctx,
  )

  component.main-content(
    kind: kind,
    draft: draft,
    body,
    ctx: ctx,
  )

  component.back-matter(
    kind: kind,
    outlines: if outlines-position == end { outlines },
    outlines-force-empty: outlines-force-empty,
    appendices: appendices,
    glossary: glossary,
    bibliography: bibliography,
    acknowledgement: if acknowledgement-position == end { acknowledgement },
    affidavit: if affidavit-position == end { affidavit },
    affidavit-force: affidavit-force,
    ctx: ctx,
  )
}
