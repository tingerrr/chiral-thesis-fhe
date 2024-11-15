#import "ctx.typ" as _ctx

// TODO: arg validation
#let doc(
  doc: (:),
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
  import "core/component.typ"
  import "core/styles.typ"

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

  show: styles.document(draft: mode == "draft", ctx: ctx)

  component.prelude(doc: doc, abstracts: abstracts, ctx: ctx)

  show: styles.post-abstract(
    faculty: doc.faculty,
    ctx: ctx,
  )

  component.front-matter(
    doc: doc,
    acknowledgement: if acknowledgement-position == start { acknowledgement },
    affidavit: if affidavit-position == start { affidavit },
    affidavit-force: affidavit-force,
    outlines: if outlines-position == start { outlines },
    outlines-force-empty: outlines-force-empty,
    ctx: ctx,
  )

  component.main-content(
    doc: doc,
    draft: mode == "draft",
    body,
    ctx: ctx,
  )

  component.back-matter(
    doc: doc,
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
