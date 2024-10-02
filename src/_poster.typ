#import "core/authors.typ"

#import "/src/ctx.typ" as _ctx
#import "/src/theme.typ" as _theme
#import "/src/utils.typ" as _utils

// TODO: cleanup of spacing and layout code
// TODO: use FHE AI logo, not just FHE logo
#let poster(
  kind: (:),
  image: none,
  cv: par(justify: true, lorem(75)),
  theme: _theme.themes.applied-computer-science,
  _fonts: _fonts,
) = body => {
  set text(font: _fonts.sans)

  let title = {
    set text(size: 78pt)
    kind.title
  }

  let supervisors = {
    set text(size: 32pt, fill: theme.secondary, weight: "bold")
    [Betreuer: ]
    kind
      .supervisors
      .map(authors.format-author.with(email: false))
      .join(", ", last: " und ")
  }

  let faculty = {
    set text(size: 30pt)
    [
      Studiengang Angewandte Informatik,
      Altonaer Str. 25 99085 Erfurt,
      Tel. 0361 6700 642,
      e-mail: informatik\@fh-erfurt.de
    ]
  }

  let cv = {
    grid(
      columns: (auto, auto, 0pt),
      align: horizon,
      gutter: 3cm,
      block(width: 105mm, height: 140mm, fill: theme.accent-primary),
      {
        text(size: 54pt, strong(
          authors.format-author(kind.author, email: false, titles: false)
        ))
        linebreak()
        text(size: 42pt, cv)
      },
      none
    )
  }

  let separator = theme.secondary + 0.2cm

  set page(
    paper: "a0",
    margin: 0pt,
    background: grid(
      columns: (3cm, 1fr, 13.15cm, 14cm),
      rows: (4.8cm, 11cm, 18cm, 1fr, 4cm),
      align: top + left,
      // header
      grid.cell(fill: theme.accent-primary, none),
      grid.cell(fill: theme.accent-primary, none),
      grid.cell(fill: theme.primary, none),
      grid.cell(fill: theme.accent-primary, none),

      // title and logo
      none,
      grid.cell(
        inset: (top: 1.8cm, bottom: 0.9cm),
        {
          set align(top)
          strong(title)
          set align(bottom)
          supervisors
        }
      ),
      grid.cell(
        colspan: 2,
        inset: (top: 1.8cm, right: 1.75cm),
        std.image("/assets/images/logo-fhe.svg", width: 100%)
      ),

      // faculty and cv info
      none,
      // NOTE: since we can't control the alignment of the stroke yet we need to
      // ensure that the top and bottom lines don't protrude on the x axis
      block(
        width: 100%,
        stroke: (top: separator),
        inset: (top: 0.5cm, bottom: 1cm), {
          set align(top)
          faculty
          set align(bottom)
          cv
      }),
      grid.cell(
        rowspan: 2,
        fill: gradient.linear(angle: 90deg, theme.accent-primary, white),
        block(
          width: 100%,
          stroke: (top: separator),
          none,
        ),
      ),
      none,

      // main content
      none,
      block(
        width: 100%,
        stroke: (top: separator),
        none,
      ),
      none, none,

      // footer
      none, none, none,
      grid.cell(fill: theme.accent-secondary, none),
      grid.cell(fill: theme.accent-secondary, none),
      grid.cell(fill: theme.secondary, none),
      grid.cell(fill: theme.accent-secondary, none),
    )
  )

  grid(
    columns: (3cm, 1fr, 3cm),
    rows: (33.8cm, 1fr, 4cm),
    inset: (y: 2cm),
    none, none, none,
    none, body, none,
    none, none, none,
  )
}

