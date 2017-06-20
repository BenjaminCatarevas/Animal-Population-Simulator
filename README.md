# Lotka-Volterra-Simulation
This is a simulation of animal population growth and decay using Processing, a subset of Java. This is implemented through equations known as the Lotka-Volterra Equations. In this simulation, rabbits and foxes are the two chosen animal populations.
The interesting aspect of the Lotka-Volterra equations is that when ran, given the right settings, a cycle begins to occur, where history repeats itself. The simulator comes built in with such settings.

# Customizable settings Settings
The user can change things such as the alpha, beta, gamma, delta, time step, and the initial population values.
- Alpha refers to the rate at which the rabbits grow
- Beta refers to the crossproduct of rabbits and foxes, which in turn determines the overall amount of rabbits
- Delta refers to the rate at wihch foxes grow
- Gamma refers to the crossproduct between the rabbits and foxes, which in turn determines the overall amount of foxes

# Graphs
There are also data visualization implementations in this simulation, through the use of three different graph types:
- Line graph, which plots both populations on an x-y based graph, where x is time and y is the population for each population
- Bar graph, which plots each population as it grows and decays
- Phase-space graph, which plots rabbits versus foxes on an x-y graph, where x is rabbits and y is foxes. The phase-space graph also scales itself in case it reaches a new maximum that would otherwise go off the graph.

# How To Use
1. Download the Processing IDE [here](https://processing.org/download/)
2. Open the .pde file in the Processing IDE, then click the Run button.
