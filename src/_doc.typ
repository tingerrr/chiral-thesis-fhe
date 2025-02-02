#import "core/component.typ" as _component
#import "core/styles.typ" as _styles
#import "ctx.typ" as _ctx
#import "utils.typ" as _utils

// TODO: arg validation
// TODO: provide good defaults
#let doc(
  kind: (:),
  mode: "draft",
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
  if mode == "strict" {
    if bibligography == none {
      panic("missing bibliography")
    }

    if affidavit == none {
      panic("missing affidavit")
    }

    context {
      let todos = query(ctx.labels.todo)
      if todos.len() != 0 {
        // NOTE: we assume TODOs only exist within the content, this will be
        // slightly wrong for the appendix, but we cannot yet get the page
        // numbering at a location, so this is still better than the physical
        // page number in most casese
        let pages = todos.map(t => counter(page).at(t.location()).first()).join(", ", last: " and ")
        panic("Remaining TODOs found on pages " + pages)
      }
    }
  }

  show: _styles.document(draft: mode == "draft", ctx: ctx)

  _component.prelude(kind: kind, abstracts: abstracts, ctx: ctx)

  show: _styles.post-abstract(
    faculty: kind.field,
    ctx: ctx,
  )

  _component.front-matter(
    kind: kind,
    acknowledgement: if acknowledgement-position == start { acknowledgement },
    affidavit: if affidavit-position == start { affidavit },
    affidavit-force: affidavit-force,
    outlines: if outlines-position == start { outlines },
    outlines-force-empty: outlines-force-empty,
    ctx: ctx,
  )

  _component.main-content(
    kind: kind,
    draft: mode == "draft",
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
