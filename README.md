# chiral-thesis-fhe
This is a thesis template for the [University of Applied Sciences Erfurt][fhe] (FHE). It provides
scaffolding for a [Typst] project which can be used to write a bachelor's thesis, mastere's thesis,
or simple a report in the style mandated by the university.

The template package provides scaffolding and defaults in both German, but may later be extended
to english.

The default thesis scaffold contains 5 common chapters with some lorem and examples for figures,
tables and other useful features. Lastly, it contains a README.md detailing the structure and
explaining how to add and remove optional parts of the document.

## Exmaple
TODO

## TODO
The following tasks remain before publishing on Typst Universe.
- [x] Get into a workable state
- [ ] Separate styles into optional and mandatory styles for easier picking and chosing
  - [ ] Provide more common defaults
- [ ] Fix anti-matter and use it again
- [ ] Provide better error messages on incorrect inputs
- [x] Ensure abstracts are part of the PDF outline by using unstyled headings
- [ ] Document package API and template README.md
- [ ] Add metadata for post document checking (no remaining todos, correct layout choices)
- [ ] Correctly separate fonts and resources or implement resources in Typst
- [ ] Passthrough values to `set document`

## Documentation
The documentation for this package can be viewed in the [manual]. A changelog is curated
[here][changelog] and the initialized project contains a [README][template-readme] explaining how
to get started.

## Contribution
To contribute, simply open an issue to discuss a possible feature or problem that needs fixing. If
you found an obvious bug, feel free to open a PR directly. PRs will automatically run regression
tests, but for rapid local development consider installing some of the tools listed below.

### Tools
- `typst` 0.11.0 to compile examples, docs and tests
- `just` to run the recipes used for development and testing
  - `oxipng` for running the `doc` recipe
- `typst-test` to run regression tests

## Etymology
The default looks of the word and LaTeX templates are fairly LaTeX-typical in appearance. The 
non-descriptive "chiral" is a word play on this being the mirrored partner to the LaTeX template,
as well as on the last letter of LaTeX being the greek letter chi.

[fhe]: https://fh-erfurt.de/
[typst]: https://typst.app/home

[manual]: ./docs/manual.pdf
[changelog]: ./CHANGELOG.md
[template-readme]: ./template/README.md
