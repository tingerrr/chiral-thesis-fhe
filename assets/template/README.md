## Conventions
This template, in particular the boilerplate you see here, is written with some convetions in mind, you don't need to follow these convetions, but they can help you navigate your own document as it is growing. For the purposes of this README, we'll assume you stick to these, but you can pick and chose what ever you like. The template code should be able to handle whatever you throw at it, as long as it's configured right.

Most of the files contain comments explaining some of the existing code, read them at your own pace or ignore them if you know what you're doing.

### References
Most labels are prefixed with some short kind of identifier to make it easier to find the label you're trying to reference in the list of auto completions. They're listed here in no particular order:
- document structure
  - `chap:` - for chapters
  - `sec:` - for sections, subsections, etc.
- figures
  - `fig:` - for images and other figures
  - `lst:` - for listings
  - `tbl:` - for tbales
- `bib:` - for bibliography references

When typing `@` your editor will show all labels, this helps narrow down the completions, but is completely optional.

### Thesis Structure
The following directories and files are created by default:
- `main.typ` - The entrypoint of your thesis document, this is what you pass to `typst compile` or enable as preview in your preferred editor.
- `packages.typ` - The package file where packages are imported, importing them once here and importing this in your other files means that upgrading and downgrading packages is easier.
- `chapters` - Contains a Typst file per chapter. Most of your content will be here, save for some supplementary material like abstracts, acknowledgements and such.
- `bibliography.yaml` - The bibliography used in this thesis. You can simply import your own `.bib` file, use a reference manager, or use this file as an entrypoint to get started with [hayagriva], Typst's native bibliography managment system.
- `assets/figures` - Contains your figures, whether they be `.svg`, `.png`, or fully fletched `.typ` files containing [cetz] or [fletcher] figures.
- `assets/fonts` - Contains the fonts your document uses, these will be populated with _Latin Modern Sans_, this is required to match the current templates used at FHE.

The template generally assumes that these top level files and directories live within the root of your repository or project/thesis folder. You can just as easily put them all in a src folder, as long as you either start compilation from within that folder, or adjust either the `--root` option, or the absolute paths of `import`s and `include`s.

[hayagriva]: https://github.com/typst/hayagriva
[cetz]: https://typst.app/universe/package/cetz
[fletcher]: https://typst.app/universe/package/fletcher
