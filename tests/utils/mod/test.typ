#import "/src/utils.typ"

#set page(height: 1cm, width: 1cm)

#context {
  assert(utils.is-within-markers(<inside>, <marker>))
  assert(not utils.is-within-markers(<outside>, <marker>))
}

#metadata(()) <outside>
#pagebreak()
#metadata(()) <marker>
#pagebreak()
#metadata(()) <inside>
#metadata(()) <marker>
