# About
This program models an epidemic and displays the final results as a graph.
You will be asked to enter some information, such as the population size,
number of days latent, etc. The program will then start the simulation with
three potential states for each agent: Infectious, immune, and susceptible. 
Infectious agents randomly infect susceptible agents, causing them to enter
a fourth state: latent. Latent agents will become infectious after a
user-specified amount of days. Infectious agents will eventually stop being 
infectious after a user amount of days. At this time, are considered to be
the fifth state: Recovered. The simulation ends when there are no infectious
or latent agents left in the population.

The graph has edges between agents who contacted each other, and only shows
the end of the simulation when there are only 3 possible states:
Susceptible (green)
Immune (orange)
Recovered (blue)

NOTE: The number of immune agents will be rounded down. For example, with a 
population of 10 that has 35% immunity, only 3 agents wil be immune.
