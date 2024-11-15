#import "../packages.typ": *
#import ctf.prelude: *

= Modes
The template has two modes, draft mode and print mode.
Draft mode aids in review, while print mode makes the document print ready.
By default, the document will be in draft mode and can be set to print mode by passing `draft: false` to the template function.

== Draft mode
When in draft mode the template does the following:
- decrease the left margin and increase the right margin to make space for reviwer notes
- add a draft water mark
- add line numbers for referencing parts of prose

== Print mode
When in print mode the template does the following:
- alternate margin size to accout for page binding
- remove draft water mark
- remove line numbers
