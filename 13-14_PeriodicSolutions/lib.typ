// University Assignment Template
// Usage: #import "template.typ": *
// Then call: #show: university-assignment.with(
//   title: "Your Title",
//   subtitle: "Your Subtitle",
//   author: "Your Name",
//   details: (
//     course: "ECSE 303",
//     supervisor: "Prof. Smith",
//     due-date: "September 19, 2025",
//     hardware: "Raspberry Pi, LED, resistor",
//     software: "C (WiringPi), Python (RPi.GPIO)",
//     duration: "~3 hours",
//   ),
//   date: datetime.today()
// )

#let university-assignment(
  title: "Assignment Title",
  subtitle: none,
  author: "",
  details: (:),
  date: datetime.today(),
  body
) = {
  // Page setup
  set page(margin: 1in)
  set text(size: 10pt)
  set heading(numbering: "1.")
  
  // Custom code block styling
  show raw.where(block: true): it => align(center)[
    #block(
      radius: 8pt,
      fill: luma(240),
      inset: 1em,
      stroke: none,
      breakable: false,
      width: 80%,
    )[
      #it
    ]
  ]

  show raw.where(block: false): it => box(
    fill: luma(245),
    inset: (x: 3pt, y: 0pt),
    outset: (y: 3pt),
    radius: 2pt,
  )[#text(font: "MesloLGL Nerd Font", size: 0.9em)[#it]]
  
  show block.where(fill: rgb("#f0f8ff")): it => align(center, it)
  
  // Custom heading styles
  show heading.where(level: 1): it => [
    #set align(left)
    #set text(size: 20pt, weight: "bold")
    #block()[#it]
    #line(length: 100%, stroke: 0.5pt + rgb("#000000"))
    #v(0.5em)
  ]
  
  show heading.where(level: 2): it => [
    #set text(size: 18pt, weight: "semibold", fill: rgb(50, 50, 50))
    #block(above: 1.2em, below: 0.8em)[#it]
  ]
  
  // Simple emphasis and strong styling
  show emph: it => text(style: "italic", weight: "medium")[#it.body]
  show strong: it => text(weight: "bold")[#it.body]
  
  // Simple list styling
  show list: it => block(above: 0.6em, below: 0.6em)[#it]
  
  // Simple quote styling
  show quote: it => block(
    align(center),
    fill: luma(248),
    stroke: (left: 3pt + luma(180)),
    inset: (left: 1em, rest: 0.8em),
    radius: (right: 3pt),
  )[
    #set text(style: "italic")
    #it
  ]
  
  // Enhanced title page
  align(center)[
    #v(1.5em)
    #block(
      radius: 12pt,
      inset: 2em,
      stroke: 2pt,
    )[
      #text(size: 28pt, weight: "bold")[
        #title
      ]
      #if subtitle != none [
        #v(0.5em)
        #text(size: 20pt, weight: "semibold")[
          #subtitle
        ]
      ]
    ]
    #v(0.3em)
    #stack(
      dir: ltr,
      spacing: 1em,
      text(size: 20pt, weight: "bold")[#author],
      text(size: 20pt, fill: rgb(100, 100, 100))[#date.display("[month repr:long] [day], [year]")],
    )
    #v(2em)
  ]
  
  body
}

// Example usage:
/*
#show: university-assignment.with(
  title: "Lab 3: GPIO and LED Control",
  subtitle: "Embedded Systems",
  author: "Your Name",
  details: (
    course: "ECSE 303",
    supervisor: "Michael Goldberg",
    due-date: "September 19, 2025",
    hardware: "Raspberry Pi, LED, resistor",
    software: "C (WiringPi), Python (RPi.GPIO)",
    duration: "~3 hours",
  ),
  date: datetime.today()
)

= Introduction
Your content here...
*/
