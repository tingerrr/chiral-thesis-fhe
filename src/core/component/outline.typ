#import "/src/utils.typ" as _utils

#let make-outline(
  target: image,
  title: auto,
  force-empty: false,
  _state: _utils.state.outline,
) = context {
  if force-empty or query(figure.where(kind: target)).filter(f => f.caption != none).len() != 0 {
    show outline: set heading(numbering: none, outlined: true, offset: 0)

    _state.update(true)
    outline(target: figure.where(kind: target), title: title)
    _state.update(false)
  }
}
