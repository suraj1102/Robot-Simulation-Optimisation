#import "lib.typ": *

#show: university-assignment.with(
  title: "Two Spring Damper System",
  subtitle: "P12. Numerical Optimization",
  author: "Suraj Dayma",
)

= Problem

Consider the surface $z = (x(x-y))^2 - e^(-x^2-y^2) - cos(x)$

Consider the plane $x + y + z/3 = 0$

Find minimum of z that is on the surface, on the plane, and inside the unit circle. Also find the points $x$ and $y$ at which this minima occurs. 

= Plot of Surfaces

#figure(
  image(
    "imgs/3dPlot.png"
  ),
  caption: [Surfaces]
)

= GridSearch

#figure(
  ```matlab
    function [X_minz, Y_minz, minZ] = gridSearch(X, Y, zSurface, zPlane, tol)
      % Matlab doesn't support default argumnets so this is the stupid syntax
      if nargin < 5
          tol = 1e-4;
      end

      [X_minz, Y_minz, minZ] = deal(inf);
      for i = 1:size(X, 1)
          for j = 1:size(X, 2)
              x_ij = X(i, j);
              y_ij = Y(i, j);
              z_ij_surf = zSurface(i, j);
              z_ij_plane = zPlane(i, j);

              
              if (abs(z_ij_plane - z_ij_surf) >= tol)
                  continue
              end

              if (x_ij^2 + y_ij^2 > 1)
                  continue
              end
              
              if (z_ij_plane >= minZ)
                  continue
              end

              X_minz = x_ij;
              Y_minz = y_ij;
              minZ = z_ij_plane;
          end
      end
  end
  ```,
  caption: [Grid Search Function Implementation]
)

As I am just comparing the points with some tolerance in this function, we would get better accuracy as we sample more points and change the `numPoints` parameter.

#figure(
  image("imgs/gridSearchMinima.png"),
  caption: [Minima Found Using GridSearch]
)

In the above figure the output was: `Gridsearch Minima(Z): X: 0.28529 Y: 0.31331 Z: -1.7958`

= `fmincon` Solution

#figure(
  ```matlab
  function [X_fmin, Y_fmin, Z_fmin] = fminconMinimize()
      obj = @(v) myPlane(v(1), v(2));
      nonlcon = @(v) deal(
          [ v(1)^2 + v(2)^2 - 1 ], % nl ineq
          [ mySurface(v(1), v(2)) - myPlane(v(1), v(2)) ] % nl eq
      );
      
      v0 = [0, 0];
      
      [v_opt, z_opt] = fmincon(obj, v0, [], [], [], [], [], [], nonlcon);
      
      X_fmin = v_opt(1);
      Y_fmin = v_opt(2);
      Z_fmin = z_opt;    
  end
  ```,
  caption: [Implementation of `fmincon` Constraints]
)

Output of fmincon function: `fmincon Minima(Z): X: 0.23576 Y: 0.36419 Z: -1.7999`

= Grid Search Method Error

Two errors were computed for the grid search method:
1. Absolute z error: `abs(Z_fmincon - Z_gridsearch)`
2. Distance Error: `sqrt( (x_fmin - x_gs)^2 + (y_fmin - y_gs)^2 )`

#figure(
  image("imgs/erros.png"),
  caption: [Error in GridSearch]
)
