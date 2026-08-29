#import "lib.typ": *

#show: university-assignment.with(
  title: "Two Spring Damper System",
  subtitle: "P.11 Robot Motion, Simulation, Optimization",
  author: "Suraj Dayma",
)

= Intro

System animation, fixed point analysis and clustering, and linear stability analysis for the *Two Spring and Two Damper System* with drag.

= Problem and Dynamics:

#figure(image("imgs/equations.png", width: 70%), caption: [Force Balance])

= Fixed Points

The fixed points were found using `fsolve`, and clustering of fixed points was performed by using the following algorithms:
1. KMeans: within cluster sum of squares was found was varying K and the best K was determined by the elbow method.
2. DBScan: the distance parameter was kept very small (0.005) which converged correctly for every scenario I tried (except the infinite fixed point cases).

== Fixed Points = 2


#grid(
  columns: (35%, 1fr),
  column-gutter: 1em,
  figure(
    ```matlab
    % System Constants
    p.m = 1;
    p.g = 10;

    p.b1 = 1;
    p.b2 = 1;

    p.d = 0.6; % drag coef

    p.k1 = 1;
    p.k2 = 10;
    p.l1_0 = 1;
    p.l2_0 = 1;

    p.r1 = [-1; 0];
    p.r2 = [1; 0];
    ```
  ),
  figure(
    image("imgs/2FP.png", width: 100%),
    caption: [Fixed Points]
  )
)

Both KMeans and DBScan provided the right answer for this.

== Fixed Points = 5

#grid(
  columns: (35%, 1fr),
  column-gutter: 1em,
  figure(
    ```matlab
    % System Constants
    p.m = 1;
    p.g = 0;

    p.b1 = 1;
    p.b2 = 1;

    p.d = 1; % drag coef

    p.k1 = 10;
    p.k2 = 10;
    p.l1_0 = 1.5;
    p.l2_0 = 1.5;

    p.r1 = [-1; 0];
    p.r2 = [1; 0];
    ```
  ),
  figure(
    image("imgs/clustering/5FP.png", width: 100%),
    caption: [Fixed Points]
  )
)


#figure(
  image("imgs/clustering/5FP-KMeans.png", width: 60%),
  caption: [KMean - Best K = 3]
)
#figure(
  image("imgs/clustering/5FP-DB.png", width: 70%),
  caption: [DBScan - Correct Identification]
)

== Fixed Points = 1

#grid(
  columns: (35%, 1fr),
  column-gutter: 1em,
  figure( ``` matlab
  % System Constants
  p.m = 1;
  p.g = 10;

  p.b1 = 1;
  p.b2 = 1;;

  p.d = 1; % drag coef

  p.k1 = 10;
  p.k2 = 10;
  p.l1_0 = 1;
  p.l2_0 = 1;

  p.r1 = [-1; 0];
  p.r2 = [1; 0];
  ``` ),
  figure(
    image("imgs/1FP.png", width: 100%),
    caption: [Fixed Points]
  )
)

Both KMeans and DBScan provided the right answer for this.

== Fixed Points = 4, Two of them are very close

#grid(
  columns: (35%, 1fr),
  column-gutter: 1em,  
  figure(``` matlab
% System Constants
p.m = 1;
p.g = 0;

p.b1 = 1;
p.b2 = 1;;

p.d = 1; % drag coef

p.k1 = 10;
p.k2 = 10;
p.l1_0 = 1;
p.l2_0 = 1;

p.r1 = [-1; 0];
p.r2 = [1; 0];
```),
figure( 
  image("imgs/clustering/closeFP.png", width: 100%),
  caption: [Fixed Points]
)
)

#figure(image("imgs/clustering/closeFP-zoomed.png", width: 50%),
caption: [2 Fixed Points Closeby])


#figure(
  image("imgs/clustering/closeFP-KMeans.png", width: 60%),
  caption: [KMean - Best K = 3: WRONG]
)
#figure(
  image("imgs/clustering/closeFP-DB.png", width: 70%),
  caption: [DBScan - Correct Identification]
)

== Fixed Points = 3


#grid(
  columns: (35%, 1fr),
  column-gutter: 1em,
  figure(
    ``` matlab
    % System Constants
    p.m = 1;
    p.g = 1;

    p.b1 = 1;
    p.b2 = 1;

    p.d = 1; % drag coef

    p.k1 = 1;
    p.k2 = 1;
    p.l1_0 = 1;
    p.l2_0 = 2;

    p.r1 = [-1; 0];
    p.r2 = [1; 0];
    ``` ),
  figure(
    image("imgs/3FP.png", width: 100%),
    caption: [Fixed Points]
  )
)

DBScan was correct all the times, KMeans sometimes said best K was 2, while other times said it was 3.


== Fixed Points = Infinite

When gravity is off, and either of the spring constants are zero, all points on the free length circle of the active spring are valid unique fixed points.

#figure(
  image("imgs/infFP.png", width: 70%),
  caption: [g = 0, k1 = 0 => inf FP]
)

Also when gravity is off, and both the springs are active, but the anchor positions are the same, we get infinite fixed points.

#figure(
  image("imgs/infFP2.png", width: 70%),
  caption: [g = 0, rA=rB => inf FP]
)


= Linearised Motion 

*Task:*
- Using the Jacobian supplied by fsolve at one of the stable fixed points, solve the linearized equations for motion for an initial condition near the fixed point.
- Using the same initial condition, use ODE45 to find the motion.
- Repeat for an unstable fixed point

*System Used:* 
The same parameters that resulted in 3 fixed points were used.

Stable Fixed Points:
- [-1; 0]
- [-0.5323; -1.7316]

Unstable Fixed Points:
- [1.2412; 0.2169]

== Response near stable fixed point
#figure(
  image("imgs/linResponseStable.png", width: 70%)
)

== Response near unstable fixed point
#figure(
  image("imgs/linResponseUnstable.png", width: 70%)
)

== Response When L0 = 0, b = 0
#figure(
  image("imgs/linResponseAllZero.png", width: 70%)
)
#figure(
  image("imgs/linResponseAllZero2.png", width: 70%)
)
