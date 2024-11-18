/// The default fonts.
#let default-fonts = (
  /// The serif font, this is used in prose.
  serif: "Libertinus Serif",
  /// The sans-serif font, this is used for headings, figure captions, headers
  /// and footers.
  sans: "Latin Modern Sans",
  /// The monospaced font, this is used in raw elements.
  mono: "DejaVu Sans Mono",
)

/// The default colors.
#let default-colors = (
  /// The citation id color, this is used to highlight citation identifiers.
  cite: purple,
  /// The hyperlink color, this is used to highlight hyperlinks.
  ///
  /// This is currently unused, because it interferes with all other links.
  link: eastern,

  // TODO: add default faculty colors here
)

/// The default states used for various internal introspections.
///
/// These are mainly useful for debugging, or to swap out states with clashing
/// identifiers.
#let default-states = (
  /// The outline state used for smart captions.
  in-outline: state("ctf:state:outline", false),
  /// The appendix state used for outlines.
  in-appendix: state("ctf:state:appendix", false),
)

/// The default labels used for various internal introspections.
///
/// These are mainly useful for debugging, or to swap out labels with clashing
/// identifiers.
#let default-labels = (
  /// Used to retrieve the page numbering at the end of the front matter.
  front-matter-anchor: <ctf:marker:front-matter>,
  /// Used to mark the beginning and end of blank pages.
  pagebreak: (
    start: <ctf:marker:pagebreak:start>,
    end: <ctf:marker:pagebreak:end>,
  )
)

/// The default context object.
#let default = (
  fonts: default-fonts,
  colors: default-colors,
  states: default-states,
  labels: default-labels,
)

/// Place an invisible marker with the given key.
#let marker(name) = [#metadata(none)#name]

/// Check whether the current page is a blank page created by a `pagebreak`.
///
/// This function is contextual.
///
/// - ctx (ctx): The ctf-context.
/// -> bool
#let is-blank-page(ctx: default) = {
  let page-num = here().page()
  let markers = selector.or(
    ctx.labels.pagebreak.start,
    ctx.labels.pagebreak.end,
  )
  query(markers).chunks(2).any(((start, end)) => {
    start.location().page() < page-num and page-num < end.location().page()
  })
}

/// Create a smart caption with a given short and long content.
///
/// - short (content): The short content to display in the outline.
/// - long (content): The long content to display inline.
/// -> context
#let smart-caption(short, long, ctx: default) = context if ctx.states.in-outline.get() {
  short
} else {
  long
}
