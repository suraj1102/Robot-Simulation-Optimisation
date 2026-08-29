#import "lib.typ": *

#show: university-assignment.with(
  title: "Homework 06",
  subtitle: "Robotic Motion",
  author: "Suraj Dayma",
)

= Question 13

*Question*: Finding periodic motions.

== Q13-A
Verify, using numerical solutions, that for $dot.double(arrow(r)) = -k/m arrow(r)$ that for any and all initial conditions you get periodic motions (straight lines, circles, or elipses). Extra credit, verify this with pencil and paper. This is a ‘linear’ central force’.

The given ODE is similar to the equation $dot.double(x) = - lambda x$ which yields the general solution of $x(t) = A sin(lambda t) + B cos(lambda t)$ for any constants $A, B$. $therefore$ the solution to $dot.double(arrow(r)) = -k/m arrow(r)$ must also be periodic in nature for any given $k, m$.

To verify this, I added the constraint in the `fsolve` objective function that the terminal and initial states must all be the same.

#figure(
  ```matlab
  function error = periodicResidualAllStates(all_init, problemODE, p)
      z0 = all_init(1:4);
      T = all_init(5);

      RHS = @(t, z) problemODE(z, p);
      sol = ode45(RHS, [0 T], z0);

      z_T = deval(sol, T);
      error = [
          z0 - z_T; % Return back to same point
          p.z0(1) - z_T(1); % Enforce x0_converged = x0
          p.z0(2) - z_T(2); % Enforce y0_converged = y0
          p.z0(3) - z_T(3); % Enforce vx0_converged = vx0
          p.z0(4) - z_T(4); % Enforce vy0_converged = vy0
          % Use p.z0 as all_init passed into function changes as algo.
          % converges
      ];
  end
  ```,
  caption: [fsolve Objective Function],
)


For random initial conditions the periodic solution were found, and the norm of the error was computed and shown below in the results.

#figure(
  image("imgs/A-allSolsPeriodic.png", width: 100%),
  caption: [Results],
)

#figure(
  image("imgs/A-Solution.png", width: 100%),
  caption: [A Solution],
)

== Q13-B

System:
$
  dot.double(bold(arrow(r))) & = - (G M) / r^3 bold(arrow(r)) \
                             & = - (G M) / r^3 r hat(r) \
                             & = - (G M) / r^2 hat(r) \
                        => F & prop 1 / r^2 therefore "inverse square law"
$

Choosing $G=M=1$ and sampling points around the state $arrow(bold(r))_0 = [1, 0] arrow(bold(v)) = [0, 1]$, the same approach as the previous question is used to find out if solutions are periodic or not.

#figure(
  image("imgs/B-results.png", width: 100%),
  caption: [Results],
)

All entries with T close to 0 or NaN are invalid. One of these invalid and valid solutions is shown below.

#figure(
  image("imgs/B-periodicSolution.png", width: 80%),
  caption: [Q13-B: A Periodic Solution],
)

#figure(
  image("imgs/B-nonPeriodicSolution.png", width: 80%),
  caption: [Q13-B: A Non Periodic Solution],
)

= Q13-C

System:
$
  dot.double(arrow(r)) = -k r^(n-1) arrow(r) \
  k > 0 " & " n eq.not 1,-2
$

I selected $k=1$ and $n=2$

#figure(
  image("imgs/C-straighLine.png", width: 75%),
  caption: [Straight Line Motion towards origin if we start at rest],
)

#figure(
  image("imgs/C-Circle.png", width: 75%),
  caption: [Circular motion if $v_y$ != 0],
)

= Q13-D

*Show that for the above problem, for random initial conditions you do not generally get periodic motions.*

#figure(
  image("imgs/D-nonPeriodic.png", width: 85%),
  caption: [n=-1, random z0],
)
#pagebreak()
We can easily see this from the error table I have been making.
#image("imgs/D-Results.png")
The error term is sometimes close to zero (periodic motion) and sometimes way off (non periodic). The above figure is from the last entry of the table with an error of $approx 7.75$.

= Q13-E

$
  dot.double(arrow(r)) = -k r^(n-1) arrow(r) \
  k > 0 " & " n eq.not 1,-2
$

*Find a non circular and non straight line periodic motion:*

#figure(
  image("imgs/E-nonCircularPeriodicMotion.png", width: 80%),
  caption: [n=3, k=1, r0 = [1; 0], v0 = [2; -0.5]],
)

*What happens if $n <= -3$?*
- I didn't notice any periodic motions from what I tested with.
- I think this is because at $n <= -3$, the force drops off very quickly and is not enough to pull the mass back in.
- Asking Gemini, it gave me a slightly complicated explaination involving the potential field of the force and the angular momentum of the system which I didn't fully understand.

= Q13-F
*Find periodic motions in the two spring mass damper system with g=0, all damping=0, and anchors not vertically aligned*

The error term for all configurations I tried was too large to give periodic motion even if I increased the number of points. I am not sure if that is due to a bug in my rootfinding.

