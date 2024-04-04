#import "/src/packages.typ" as _pkg

#let std = assert

#let text(name, value) = {
  if type(value) not in (str, content) {
    panic(_pkg.oxifmt.strfmt("`{}` must be text, was of type `{}`", name, type(value)))
  }
}
