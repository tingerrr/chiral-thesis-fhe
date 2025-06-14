#import "../packages.typ": *
#import ctf.prelude: *

= Prelude and Packages
We'll go over some source code basics here, the next chapter showcases various styles the template applies.
Most chapters include the imports seen in this file:
- ```typ #import "../packages.typ": *``` imports all packages in the packages file, this way you can update the package once instead of everywhere.
- ```typ #import ctf.prelude: *``` imports the prelude of your template, this contains a few default functions such as `chapter`, `q` or `smartcap`.

These are explained below, but you can skip them for now and go straight to @chap:basics if you want.

= Packages
A few packages are pinned to versions that definitely work with this template, these include:
- `glossarium:0.4.1`
- `lovelace:0.3.0`
- `subpar:0.1.1`

The glossarium styling includes improvements such as being able to use `@term[s]` to get the plural of a of `term`, if it is a glossarium key.
The subpar and lovelace definitions are largely for styling reasons, such as numbering or stroke width.

Other packages can simply be imorted as is, it is recommended to place those alongside the example imports in the `packages.typ` file.

= Prelude
The prelude contains the following items:
/ `chapter`:
  A helper function, which forces a level 1 heading, the default styles of the template turn `= Heading` into a section, i.e. a level 2 heading, this function also adds the appropriate pagebreaks explained in @chap:printing.
/ `smartcap`:
  A helper function for long captions, receives two arguments, a short and long caption and displays the short caption in the outline and the long caption in the actual figure.
/ `glossarium`:
  A pinned version of the glossarium package.
/ `gls`:
  A re-export of `glossarium.gls`.
/ `glspl`:
  A re-export of `glossarium.glspl`.
/ `algorithm`:
  A re-export of `lovelace.pseudocode-list`.
/ `line-label`:
  A re-export of `lovelace.line-label`.
/ `doc`:
  The template function.
/ `report`:
  The template kind used in term papers.
/ `bachelors-thesis`:
  The template kind used in bachelor's theses.
/ `masters-thesis`:
  The template kind used in masters's theses.
/ `lovelace`:
  A re-export of the lovelace package with pre-applied styling.
/ `subpar`:
  A re-export of the subpar package with pre-applied styling.

= Internals
The internals are not currently documented or public API, please check out the source code to see what you can use them for.
