#import "/src/lib.typ" as ctf
#import ctf.prelude: *

#show: poster(
  // this defines how the title page is rendered and which parts are included in
  // the document, crucially, when you don't provide an affidavit but use a
  // thesis kind, then a default one is generated for you
  //
  // reports will ignore affidavits and acknowledgements
  doc: bachelors-thesis(
    id: [AI-1970-MA-999],
    title: [Mustertitel],
    author: "Max Mustermann",
    date: datetime(year: 1970, month: 01, day: 01),
    faculty: [Angewandte Informatik],
  ),

  // an image of you, you can use `image("assets/images/me.png")` for example
  image: none,

  // this is a short bit of text about you displayed next to your image
  cv: {
    set par(justify: true)
    lorem(35)
  },
)
