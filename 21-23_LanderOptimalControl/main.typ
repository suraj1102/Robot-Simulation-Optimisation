#import "lib.typ": *

#show: university-assignment.with(
  title: "Lander Optimal Control",
  subtitle: "P.21-23 Robot Motion, Simulation, Optimization",
  author: "Suraj Dayma",
)

= Lander

2D point mass drone / lander with boundary conditions, umax, z >= 0 constraints.

#figure(
  image("imgs/zeroControl.png", width: 80%),
  caption: [Sample trajectory without any control applied],
)

= Problem 21

- I used a R matrix of [5, 1] where 5 is the cost to go for ux and 1 is the cost to go for uz, so control in x direction is more expensive.

== Optimal Trajectory

With the following parameters

```matlab
N = 30
R = diag([1, 1])
umax = 20;

% 4 variables: x,z,vx,vz which will have (N+1) points
% 2 control variables: ux, uz which will have N points
% Indexing: x  - 1          : N+1
%           z  - 1(N+1) + 1 : 2(N+1)
%           vx - 2(N+1) + 1 : 3(N+1)
%           vz - 3(N+1) + 1 : 4(N+1)
%           ux - 4(N+1) + 1 : 4(N+1) + N
%           vz - 4(N+1) + N + 1 : 4(N+1) + 2N

```

#figure(
  image("imgs/optTraj-umax=20-vars.png"),
)
#figure(
  image("imgs/optTraj-umax=20-phaseplot.png"),
)
#figure(
  image("imgs/optTraj-umax=20-Thrust.png"),
)

== Feasibility Region

For same vx0 = -1, vz0 = -2:

#figure(
  image("imgs/feasibility-umax1-t5.png", width: 80%),
  caption: [Feasibility Region for umax = 1 and T = 5 | Same for (umax, T) = (1,10), (2, 5)],
)

#grid(

  rows: (1fr, 1fr),
  columns: (1fr, 1fr),
  row-gutter: -12cm,
  column-gutter: 10pt,

  figure(
    image("imgs/feasibility-umax3-t5.png"),
    caption: [umax = 3 and T = 5],
  ),
  figure(
    image("imgs/feasibility-umax2-t10.png"),
    caption: [umax = 2 and T = 10],
  ),

  figure(
    image("imgs/feasibility-umax4-t5.png"),
    caption: [umax = 4 and T = 5],
  ),
  figure(
    image("imgs/feasibility-umax2-t20.png"),
    caption: [umax = 2 and T = 20],
  ),
)

Looks like umax has more influence in determining the feasible region than the final time T.

= Problem 22 - OpenLoop Execution

#figure(
  image("imgs/openLoop-vars.png"),
)
#figure(
  image("imgs/openLoop-phaseplot.png"),
)
#figure(
  image("imgs/openLoop-error.png"),
)


= Problem 23 - MPC

#figure(
  grid(
    columns: (1fr, 1fr),
    rows: (auto, auto),
    column-gutter: 10pt,
    row-gutter: 10pt,

    image("imgs/MPC_Trajectories_Np_5.png"), image("imgs/MPC_Trajectories_Np_10.png"),
    image("imgs/MPC_Trajectories_Np_20.png"), image("imgs/MPC_Trajectories_Np_30.png"),
  ),
  caption: [Trajectories for different Np],
)

#figure(
  grid(
    columns: (1fr, 1fr),
    rows: (auto, auto),
    column-gutter: 10pt,
    row-gutter: 10pt,

    image("imgs/MPC_PhasePlot_Np_5.png"), image("imgs/MPC_PhasePlot_Np_10.png"),
    image("imgs/MPC_PhasePlot_Np_20.png"), image("imgs/MPC_PhasePlot_Np_30.png"),
  ),
  caption: [Phaseplots for different Np],
)


#figure(
  grid(
    columns: (1fr, 1fr),
    rows: (auto, auto),
    column-gutter: 10pt,
    row-gutter: 10pt,

    image("imgs/MPC_Error_Np_5.png"), image("imgs/MPC_Error_Np_10.png"),
    image("imgs/MPC_Error_Np_20.png"), image("imgs/MPC_Error_Np_30.png"),
  ),
  caption: [Errors for different Np],
)



