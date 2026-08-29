---
header-includes:
  - \usepackage{float}
  - \usepackage{graphicx}
---

# Spring and Mass

## Problem and Dynamics:

\begin{center}
\includegraphics[width=\linewidth]{./imgs/springMassDynamics.jpeg}
\small Dynamics Derivation
\end{center}

\begin{center}
\includegraphics[width=0.7\linewidth]{./imgs/ivp just outside l0, osciilatory.jpg}

\small Motion with some constants and initial value
\end{center}

## Checking the Solution

### k = 0, all else arbitrary

\begin{center}
\includegraphics[width=0.8\linewidth]{./imgs/k=0 Parabolic Flight.jpg}

\small K=0
\end{center}

### x0 = 0, vx0 = 0

\begin{center}
\includegraphics[width=0.8\linewidth]{./imgs/x,vx=0 y motion only.jpg}

\end{center}

### g = 0, v0 = 0

\begin{center}
\includegraphics[width=0.8\linewidth]{./imgs/g,v=0 Radial Motion.jpg}
\end{center}

\begin{center}
\includegraphics[width=1\linewidth]{./imgs/why radial motion.jpg}

\small Explaination of why radial motion above
\end{center}

### L0 = 0

\begin{center}
\includegraphics[width=1\linewidth]{./imgs/l0=0 explaination.jpg}
\end{center}

From the above explaination, we might expect the motion to be parabolic or elliptical as acceleration is constant.

\begin{center}
\includegraphics[width=0.8\linewidth]{./imgs/l0=0 elliptical motion.jpg}

\small Elliptical Motion
\end{center}

If vx and vy were both 0 at the initial state, then as acceleration and velocity would be constant, we would expect the motion to be a straight line.

\begin{center}
\includegraphics[width=0.8\linewidth]{./imgs/l0=0 v=0 straight line.jpg}

\small v0 = 0 and L0 = 0
\end{center}


I did notice that for the given parameters I had selected for the system:

``` MATLAB
% System Constants
p.m = 1; % Mass of bob (kg)
p.g = 10; % m/s^2
p.k = 10; % Spring coef (N/m)
p.l0 = 0; % Free Length of Spring (m)
```

When [x0, y0] = [1, 0] and vx = vy, the motion is straight line motion as opposed to elliptical.

\begin{center}
\includegraphics[width=0.8\linewidth]{./imgs/l0=0 x=1 vx=vy motion on line.jpg}

\end{center}




