#import "/src/utils/token.typ"

#set page(height: 1cm, width: 1cm)

// token-eat
#assert.eq(token.eat("Foo Bar Baz", "Bar"), (none, "Foo Bar Baz"))
#assert.eq(token.eat("Foo Bar Baz", "Foo"), ("Foo", " Bar Baz"))
#assert.eq(token.eat("Foo Bar Baz", regex("Fo+")), ("Foo", " Bar Baz"))

// token-eat-any
#assert.eq(token.eat-any("Foo Bar", ("Bar", "Baz")), (none, "Foo Bar"))
#assert.eq(token.eat-any("Foo Bar", ("Foo", "Bar")), ("Foo", " Bar"))
