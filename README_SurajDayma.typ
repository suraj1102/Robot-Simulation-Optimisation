#import "lib.typ": *

#show: university-assignment.with(
  title: "Problems Summary",
  subtitle: "Course: Robot Motion, Simulation, Optimization",
  author: "Suraj Dayma",
)
#set footnote.entry(clearance: 4pt, gap: 2pt) // Compact footnotes

#columns(2)[
  #table(
    columns: (auto, 1fr, 1fr),
    align: horizon,
    stroke: 0.5pt + gray,
    inset: 6pt,
    table.header([*Prob.*], [*% Done*], [*% Confidence*]),
    // First half
    [1], [50 #footnote("never used RP's book")], [100],
    [2], [100], [80 #footnote("Method error vs roundoff error how to find analytically - i don't know")],
    [3], [100], [100],
    [4], [100], [100],
    [5], [100], [100],
    [6], [100], [100],
    [7], [100], [70 #footnote("not very good at intuitively figuring out if system is behaving how it is supposed to")],
    [8], [70 #footnote([didn't do analytical part or best $theta$])], [80],
    [9], [100], [100],
    [10], [100], [100],
    [11], [90 #footnote("bug in my linearisation and finding jacobian - I didn't perturb the fixed point")], [100],
    [12], [100], [100],
    [13],
    [80 #footnote("some bug with the 2 spring mass system, i didn't get periodic motions with my rootfinding")],
    [80],

    [14],
    [50 #footnote("i got lazy")],
    [70 #footnote("pseudo-periodic is hard to identify and neutrally periodic is little confusing")],
  )

  #colbreak()

  #table(
    columns: (auto, 1fr, 1fr),
    align: horizon,
    stroke: 0.5pt + gray,
    inset: 6pt,
    table.header([*Prob.*], [*% Done*], [*% Confidence*]),

    [15], [100], [100],
    [16], [100], [100],
    [17], [100], [100],
    [18], [100], [100],
    [19], [70 #footnote("my ratio of error when you double h was not 4")], [100],
    [20], [100], [100],
    [21], [90 #footnote([Controllable Region Estimation and feasibility recovery not done well])], [100],
    [22], [100], [100],
    [23], [80], [80 #footnote("not very intuitive with how it handles disturbances")],
    [24], [100], [100],
    [25], [0], [30 #footnote("I understand the methodology but not the system model")],
  )
]

