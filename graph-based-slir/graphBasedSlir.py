#!/usr/bin/env python3

# Ben Diekhoff
# CMPS-5323 Computational Epidemiology
# Dr. Johnson
# 8/4/2020
# This program models an epidemic and displays the final results as a graph.
# The user will be asked to enter some information, such as the population 
# size, number of days latent, etc. The program will then start the simulation
# with three potential states for each agent: Infectious, immune, and 
# susceptible. Infectious agents randomly infect susceptible agents,
# causing them to enter a fourth state: latent. Latent agents will become 
# infectious after a user-specified amount of days. Infectious agents will 
# eventually stop being infectious after a user amount of days.
# At this time, are considered to be the fifth state: Recovered. The 
# simulation ends when there are no infectious or latent agents left in 
# the population.
# The graph has edges between agents who contacted each other, and only shows
# the end of the simulation when there are only 3 possible states:
# Susceptible (green)
# Immune (orange)
# Recovered (blue)
# The user has the option to show weighted edges, based on the amount of
# contact between two agents, but it becomes increasingly hard to read as 
# population size and contact increases.

import networkx as nx
import matplotlib.pyplot as plt
import random
from collections import defaultdict
import string

print('''
Ben Diekhoff

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
''')

G = nx.Graph()
# Description in input text
n = int(input('Enter the population size: '))
c = int(input('Enter the average contacts per person per day: '))
tr = float(input('Enter the transmission rate (between 0 and 1): '))
ii = int(input('Enter the number of initially infected: '))
dl = int(input('Enter the number of days latent: '))
di = int(input('Enter the number of days infectious: '))
pi = float(input('Enter the percent of immune agents (between 0 and 1): '))
showWeights = input('Do you want to see the weights of each connection? \
This gets cluttered as population size and contact increase. (y/n): ')
showWeights = showWeights.lower()

im = int(pi * n) # number immune
initialSusceptible = n - im - ii
totalContacts = 0 # keetps track of all contact over the simulation

# randomly detemine initial infectious, immune, and susceptible, assign 
# colors, ann assign days infectious
initSusList = []
initImmList = []
initInfList = []
colors = defaultdict(str)
statusDays = defaultdict(int)

# Susceptible
for i in range(n):
    initSusList.append(i)
    G.add_node(i)
    colors[i] = 'green'

# Infected
for i in range(ii):
    x = random.choice(initSusList)
    initInfList.append(x)
    initSusList.remove(x)
    colors[x]  ='red'
    statusDays[x] = di

# Immune
for i in range(im):
    x = random.choice(initSusList)
    initImmList.append(x)
    initSusList.remove(x)
    colors[x] = 'orange'

# stillGoing()
# Checks if latent or infectious agents still exits. If so, returns True and
# the simulation continues.
def stillGoing():
    if 'yellow' in colors.values() or 'red' in colors.values():
        return True
    else: 
        return False

# contact()
# Simulates agents randomly contacting each other. If an infectious agent
# contacts a susceptible agent, a random float between 0 and 1 is generated.
# If the float is less than the transmission rate (tr), the susceptible agent
# is infected and becomes latent. This function also returns the total number 
# of contacts that occur in a day in the simulation.
def contact():
    limit = n * c # the total contact limit per day
    count = 0 # contact count
   
    for i in range(0,limit,2):
        # reset the population
        population = []
        for j in range(n):
            population.append(j)

        # Choose two random nodes from the population
        resistance = random.random()
        x = random.choice(population)
        population.remove(x) # x is removed so it can't contact itself
        y = random.choice(population)

        # Add an edge when contact is made
        if G.has_edge(x,y):
                G[x][y]['weight'] += 1
        else:
            G.add_edge(x, y, weight = 1)
            
        # Check if the contact results in a susceptible turning into a latent
        if colors[x] == 'red' and colors[y] == 'green':
            if resistance < tr:
                colors[y] = 'yellow'
                statusDays[y] = dl
                
        if colors[y] == 'red' and colors[x] == 'green':
            if resistance < tr:
                colors[x] = 'yellow'
                statusDays[x] = dl

        # Each contact counts twice
        count +=2
    return count

# detemineStatus()
# Changes infectious agents to recovered if they've been infectious for
# the user-specified amount of days infectious (di). Does the same with 
# changing latent users to infectious after they reach days latent (dl).
def determineStatus():
    for key in statusDays:
        if colors[key] == 'red' and statusDays[key] == 0:
            colors[key] = 'blue'
        if colors[key] == 'yellow' and statusDays[key] == 0:
            colors[key] = 'red'
            statusDays[key] = di

# updateStatus()
# Decrements the amount of days an infectious or latent user has until they
# become recovered or infectious, respectively.
def updateStatus():
    for key in statusDays:
        if statusDays[key] > 0: 
            statusDays[key] -= 1

# ongoing is a flag that determines whether the simulation should continue
ongoing = True
while ongoing == True:
    updateStatus()
    determineStatus()
    totalContacts += contact()
    ongoing = stillGoing()

# Print the total number of contacts that occurred in the simulation.
print(f'\nTotal contacts: {totalContacts}')

# Show the graph
plt.figure(figsize=(9,9))
pos=nx.spring_layout(G)

if showWeights == 'y':
    labels = nx.get_edge_attributes(G,'weight')
    nx.draw_networkx_edge_labels(G,pos,edge_labels=labels, rotate = False)

nx.draw_networkx_nodes(G,pos, node_color = colors.values())
nx.draw_networkx_labels(G,pos)
nx.draw_networkx_edges(G,pos)
plt.show()