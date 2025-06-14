#import "/src/_pkgs.typ"

#let std = assert

#let text(name, value) = {
  if type(value) not in (str, content) {
    panic(_pkgs.oxifmt.strfmt("`{}` must be text, was of type `{}`", name, type(value)))
  }
}
