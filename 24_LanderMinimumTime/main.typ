#import "lib.typ": *

#show: university-assignment.with(
  title: "Lander Minimum Time",
  subtitle: "P.24 Robot Motion, Simulation, Optimization",
  author: "Suraj Dayma",
)


= Problem
- SDolve the 2d point mass lander problem as a minimum time problem.

- I added the time T as a parameter for fmincon to find.
- A lower bound for time of T >= 0.1 was also set.
- The number of points, N was fixed at 50.

= Results

For umax = 4,
p.R = diag([1, 1]);
p.Q = diag([1, 1, 1, 1]);
and same initial conditions as last problem.

#image("imgs/trajectories.png")
#image("imgs/phaseplot.png")
#image("imgs/maxThrust.png")

- The trust magnitude is at umax the whole time within the numerical error.
