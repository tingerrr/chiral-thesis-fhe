#import "../packages.typ": *
#import ctf.prelude: *

= Basic Styling
Almost all styling is applied automatically, as long as a file is included and rendered as part of your document in `main.typ`.
The following sections include some examples of how differnet part of the document are styled.

== Figures
Tables, listings and images are assumed to be used in figures.
The numbering for these three kinds of figures are adjusted to take the chapter into account.
Equations can be placed in figure, if they need captions (such as to add an attribution), but rarely are.
Likewise the numbering for equations is adjusted to do the same.

=== Tables
Tables use booktabs style separators, thin lines below and above the table while having mostly no other lines and instead using alignment to highlight rows and columns.

#figure(
  table(
    columns: 4,
    table.header(
      [Foo], [Bar], table.cell(colspan: 2)[Qux],
      none, none, [Quz], [Quv],
    ),
    ..range(20).map(x => [#x]),
  ),
  caption: [A simple table.],
) <tbl:hello>

Tables should be used in figures.
Referencing such a table looks like this: @tbl:hello.

=== Listings
Listings are shown in a similar style as tables, with two thin lines to separate them from the rest of the text.

#figure(
  ```rust
  fn main() {
    println!("Hello World!");
  }
  ```,
  caption: [A Typst code example.],
) <lst:hello>

Listings should be used in figures.
Referencing such a listing looks like this: @lst:hello.

=== Images
#let pkg(name) = link("https://typst.app/universe/package/" + name)[name]

Any image format that can be loaded, or Typst-native content drawn with packages like #pkg("cetz") #pkg("fletcher") counts as an image.
These are generally shown as is.

#figure(
  fletcher.diagram({
    import fletcher: *
    node((0, 0), stroke: 0.5pt, "eat")
    edge("-|>")
    node((1, 0), stroke: 0.5pt, "sleep")
    edge("r,d,l,l,l,u,r", "-|>", label: "repeat")
  }),
  caption: [An example fletcher diagram.],
) <fig:hello>

Referencing such a table looks like this: @tbl:hello.

=== Captions
This template provides a smart caption function which displays a different text for the caption inside the outline.

#figure(
  [Hello World],
  caption: smartcap[
    A short caption in the outline.
  ][
    A long caption in the document.
  ],
)

This caption will have a different value in the outline than it has here.

== Equations
Equations are generally not captioned, so we can just placed them into the document directly.

$
  sum_(i = 1)^n hat(c_i) <= sum_(i = 1)^n c_i
$ <eq:hello>

Referencing such an equation looks like this: @eq:hello.

== References
Most references were already shown, referenceing bibliography entries comes with stylistic enhancements which highlight the identifier and ensure the supplement (if given) is not discarded.
A normal reference may be shown like so: @bib:clrs-09, while a supplement is included but not highlighted: @bib:acr-14[p. 14].
This has the downside that multiple references are not collapsed into a single group.
Appendices also provide a differnet numbering scheme as seen in @fig:apx:hello.

== Page headers & footers
Page headers use the faculty provided with the kind in the template function, while footers contain alterting page numbering in either roman numerals or arabic numerals.

= Document structure
The document is structured as follows:
+ title page
+ abstracts
+ front matter
  + table of content
  + list of figures/table/etc.
+ main content
  + thesis chapters
+ back matter
  + bilbiography
  + appendices
  + acknowledgement
  + affidavit

== Title page
The title page is auto generated form the kind passed to the template function.

== Abstracts
The abstracts are single unnumbered pages right after the title page, which contian short vertically centered paragraphs and a single heading.
You can pass any number of abstracts to the tempalte function.

== Front matter
The front matter is numbered using roman numerals (starting at I) and contains the auto generated table of content.
By default after this, the figure outlines are included too, but can be moved to the back matter if necessary.
The figure outlines are also aut generate and can be separated by their figure kind, such as `table` for tables or `raw` for listings.

== Main content
The main content is automatically included from the rest of your entrypoint file `main.typ`, anything that's placed or included in this file after the template is main content.
The main content uses arabic numerals for its page numbers and starts at 1.

= Back matter
The back matter contains the bilbiography, appendices, acknowledgement and affidavit.
it is numbered using roman numerals (starting where the front matter left off).
The bibliography is auto generated from all refernces used and defined in the `bibliography.yaml` file.
Optional appendices are included after the bibliography and receive auto generated headings.
An optional acknowledgement can be passed to the template function to be included before the affidavit.
An affidavit can be explicitly passed to the template function, if none is provided it will be auto generated from the values given to the template function.
If the kind used in his document is not a thesis, then affidavit and acknowledgement are currently ignored.
