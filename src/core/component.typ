#import "/src/ctx.typ" as _ctx

#import "component/abstract.typ": abstract, abstracts
#import "component/acknowledgement.typ": acknowledgement
#import "component/affidavit.typ": affidavit
#import "component/appendix.typ": appendix, appendices
#import "component/glossary.typ": glossary
#import "component/outline.typ": outline, outlines
#import "component/table-of-contents.typ": table-of-contents
#import "component/title-page.typ": title-page

#let _abstracts = abstracts
#let _acknowledgement = acknowledgement
#let _affidavit = affidavit
#let _appendices = appendices
#let _glossary = glossary
#let _outlines = outlines

/// Construct the default prelude. This shows a title page and one page for each
/// abstract, all without apge numbering.
#let prelude(
  /// The document information.
  ///
  /// -> document-info
  doc: (:),

  /// The abstracts to show.
  ///
  /// You can either pass it as structured data, or as content to display
  /// directly.
  ///
  /// -> abstracts | content | none
  abstracts: (
    (title: "Kurzfassung", body: lorem(100)),
    (title: "Abstract", body: lorem(100)),
  ),

  /// The context to use.
  ///
  /// -> ctx
  ctx: _ctx.default,
) = {
  set page(numbering: none)

  title-page(doc: doc, ctx: ctx)

  if type(abstracts) == content {
    abstracts
  } else if type(abstracts) == array {
    _abstracts(abstracts: abstracts)
  }
}

/// Construct the default front matter. This will set the page numbering to be
/// roman and start at 1.
///
/// -> content
#let front-matter(
  /// The document information.
  ///
  /// -> document-info
  doc: (:),

  /// The acknowledgement to show.
  ///
  /// You can either pass it as structured data, or as content to display
  /// directly.
  ///
  /// -> acknowledgement | content | none
  acknowledgement: none,

  /// The outlines to show.
  ///
  /// By default empty outlines will be skipped unless
  /// #arg(outlines-force-empty: true) is present.
  ///
  /// You can either pass it as structured data, or as content to display
  /// directly.
  ///
  /// -> outlines | content | none
  outlines: none,

  /// Force all outlines to be shown, even if they're empty.
  ///
  /// -> bool
  outlines-force-empty: false,

  /// The affidavit to show, or a default generated one if #typ.v.auto is
  /// passed.
  ///
  /// If ther @back-matter.doc is not a thesis, then the affidavit is skipped
  /// unless #arg(affidavit-force: true) is present. This is implied if content
  /// is passed directly.
  ///
  /// You can either pass it as structured data, or as content to display
  /// directly.
  ///
  /// -> affidavit | content | auto | none
  affidavit: auto,

  /// Force the affidavit to be shown, even if the @cmd:back-matter.doc is not a
  /// thesis.
  ///
  /// -> bool
  affidavit-force: false,

  /// The context to use.
  ///
  /// -> ctx
  ctx: _ctx.default,
) = {
  import "kinds.typ"

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
    } else if (affidavit-force or kinds.is-thesis(doc.kind)) and affidavit == auto {
      _affidavit(doc: doc, body: affidavit, ctx: ctx)
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

/// Construct the default main content body. This sets the numbering to arabic,
/// starting at 1.
///
/// -> content
#let main-content(
  /// The document information.
  ///
  /// -> document-info
  doc: (:),

  /// Whether draft mode is enabled, see @cmd:document.draft.
  ///
  /// -> bool
  draft: true,

  /// The main document content.
  ///
  /// -> content
  body,

  /// The context to use.
  ///
  /// -> ctx
  ctx: _ctx.default,
) = {
  import "styles.typ"

  set page(numbering: "1")
  counter(page).update(1)

  show: styles.content(draft: draft, ctx: ctx)
  body
}

/// Construct the default back matter. This will set the page numbering to be
/// roman and continue where the front matter left off of.
///
/// -> content
#let back-matter(
  /// The document information.
  ///
  /// -> document-info
  doc: (:),

  /// The outlines to show.
  ///
  /// By default empty outlines will be skipped unless
  /// #arg(outlines-force-empty: true) is present.
  ///
  /// You can either pass it as structured data, or as content to display
  /// directly.
  ///
  /// -> outlines | content | none
  outlines: none,

  /// Force all outlines to be shown, even if they're empty.
  ///
  /// -> bool
  outlines-force-empty: false,

  /// The appendices to show.
  ///
  /// You can either pass it as structured data, or as content to display
  /// directly.
  ///
  /// -> appendices | content | none
  appendices: none,

  /// The glossary to show.
  ///
  /// You can either pass it as structured data, or as content to display
  /// directly.
  ///
  /// -> glossary | content | none
  glossary: none,

  /// The glossary to show.
  ///
  /// You can either pass it as structured data, or as content to display
  /// directly.
  ///
  /// -> bibiography | none
  bibliography: none,

  /// The acknowledgement to show.
  ///
  /// You can either pass it as structured data, or as content to display
  /// directly.
  ///
  /// -> acknowledgement | content | none
  acknowledgement: none,

  /// The affidavit to show, or a default generated one if #typ.v.auto is
  /// passed.
  ///
  /// If ther @back-matter.doc is not a thesis, then the affidavit is skipped
  /// unless #arg(affidavit-force: true) is present. This is implied if content
  /// is passed directly.
  ///
  /// You can either pass it as structured data, or as content to display
  /// directly.
  ///
  /// -> affidavit | content | auto | none
  affidavit: auto,

  /// Force the affidavit to be shown, even if the @cmd:back-matter.doc is not a
  /// thesis.
  ///
  /// -> bool
  affidavit-force: false,

  /// The context to use.
  ///
  /// -> ctx
  ctx: _ctx.default,
) = {
  import "kinds.typ"

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
    } else if (affidavit-force or kinds.is-thesis(doc.kind)) and affidavit == auto {
      _affidavit(doc: doc, body: affidavit, ctx: ctx)
    }
  }
}
