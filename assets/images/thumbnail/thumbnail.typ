#import "/src/core/component/title-page.typ": title-page
#import "/src/core/kinds.typ": thesis, kinds

#title-page(
  doc: thesis(
    id: [AI-1970-MA-999],
    title: [Mustertitel],
    author: "Max Mustermann",
    date: datetime(year: 1970, month: 01, day: 01),
    faculty: [Angewandte Informatik],
    kind: kinds.thesis-bachelor,
  )
)
