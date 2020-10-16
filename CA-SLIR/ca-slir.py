# Ben Diekhoff
# CMPS-5323 Computational Epidemiology
# Dr. Johnson
# 7/28/2020
# This program simulates the spread of a disease based on user-entered
# parameters. Generates a csv file meant to be opened in excel. Zeros are 
# susceptible individuals, ones are latent, twos are infectious, and threes
# are recovered. Each day is logged in the csv. I use conditional formatting in
# excel to simulate an outbreak. Susceptible individuals are green, latents are
# yellow, infectious are red, and recovered are blue. Black lines are used to 
# separate days.


from collections import defaultdict
import random

# neighborCheck()
# Check neighbors (Von Neummann neighborhood)
# neighbors of cells on the edges of the neighborhood are 0. For example,
# the left and top neighbors of the cell at grid[0][0] will be 0 because
# there is no grid [-1][0] or  grid[0][-1].
def neighborCheck(i,j):
    # Holds infectious neighbor locations
    neighbor = {"top": 0, "bottom": 0, "left": 0, "right": 0 }

    # Keeps track of the number of living neighbors
    infectiousNeighborCount = 0

    # if grid[i][j] == 0:
        # Check top neighbor
    if i - 1 in grid.keys():
        neighbor["top"] = grid[i - 1][j]
    else:
        neighbor["top"] = 0

    # Check bottom neighbor
    if i + 1 in grid.keys():
        neighbor["bottom"] = grid[i + 1][j]
    else:
        neighbor["bottom"] = 0

    # Check left neighbor
    if j - 1 in grid.keys():
        neighbor["left"] = grid[i][j - 1]
    else:
        neighbor["left"] = 0

    # Check right neighbor
    if j + 1 in grid.keys():
        neighbor["right"] = grid[i][j + 1]
    else:
        neighbor["right"] = 0

    # Count infectious neighbors
    if neighbor["top"] == 2:
        infectiousNeighborCount += 1
    if neighbor["bottom"] == 2:
        infectiousNeighborCount += 1
    if neighbor["left"] == 2:
        infectiousNeighborCount += 1
    if neighbor["right"] == 2:
        infectiousNeighborCount += 1

    return infectiousNeighborCount

# determineLatency()
# Determines whether or not an individual will become infected based on their
# resistance. If an individual is next to more than one infectious individual, 
# the chance of them catching the disease is multiplied by the number of
# individuals next to them.
def determineLatency(i,j):
    if grid[i][j] == 0:
        infectiousNeighbors = infectiousNeighborGrid[i][j]
        virulence = infectiousNeighbors * probabilityOfInfection
        resistance = random.random()

        if resistance < virulence:
            grid[i][j] = 1
            statusDaysGrid[i][j] = daysLatent

# determineInfectious()
# Determines when latent individuals become infectious.
def determineInfectious(i,j):
    if grid[i][j] == 1 and statusDaysGrid[i][j] == 0:
        grid[i][j] = 2
        statusDaysGrid[i][j] = daysInfectious

# determineRecovered()
# Determines when infectious individuals recover.
def determineRecovered(i,j):
    if grid[i][j] == 2 and statusDaysGrid[i][j] == 0:
        grid[i][j] = 3
        statusDaysGrid[i][j] = 0

# updateStatusDaysGrid()
# Subtracts one day from the period of the disease left for infected individuals.
# Runs once each day.
def updateStatusDaysGrid(i,j):
    if grid[i][j] == 2 or grid[i][j] == 1:
        statusDaysGrid[i][j] -= 1

# stillHappening()
# Checks to see whether or not infectious or latent individuals are still on the
# board. Stops the game if there are none.
def stillHappening():
    ongoing = False
    for i in range(n):
        for j in range(n):
            if grid[i][j] == 2 or grid[i][j] == 1:
                ongoing = True
    return ongoing
       
# Dictionary to hold the grid
# defaultdict allows the program to acess keys that don't already exist in it
grid = defaultdict(dict)
# Holds counts of infectious neighbors
infectiousNeighborGrid = defaultdict(dict)
# Holds days left of status (latent, infectious)
statusDaysGrid = defaultdict(dict)
# Whether or not there are still latent or infectious people
ongoing = True
# Used to randomly populate the grid
initialChoices = [0, 2]

# Explained in the input text
n = int(input("Enter the size you would like the square grid to be: " ))
initialInfectious = int(input("Enter the number of infectious individuals \
to start off with (must be less than or equal to your answer above): "))
daysLatent = int(input("Enter the number of days the infected individual is \
latent: "))
daysInfectious = int(input("Enter the number of days infected individuals are \
    infectious: "))
probabilityOfInfection = float(input("\nEnter the probablity of infection \
when a susceptible individual is next to a single infectious individual. \
This will be multiplied by the amount of infectious neighbors up to 4x \
and checked against a random float between 0 and 1.\nThe number you enter \
should be between 0.01 and 1: "))

# Stops the outfile from having n+1 lines in the first grid
lineBreakMod = n - 1

# Randomly insert infectious individuals
row = random.sample(range(0,initialInfectious),initialInfectious)
column = random.sample(range(0,initialInfectious),initialInfectious)



# Initialize the grid
for i in range(n): 
    for j in range(n):
        grid[i][j] = 0

# Randomly insert infectious individuals
row = random.sample(range(0,n),initialInfectious)
column = random.sample(range(0,n),initialInfectious)
for i in range(initialInfectious): 
    x = random.choice(row)
    y = random.choice(column)
    
    grid[x][y] = 2
    statusDaysGrid[x][y] = daysInfectious

    row.remove(x)
    column.remove(y)

# Write the initial grid to output.csv
with open("output.csv", "w+") as file:
    for i in range(n): 
        for j in range(n):
            file.write(str(grid[i][j]) + ",")
        file.write("\n")
        if i % n == lineBreakMod:
            file.write("\n")


# Run the simulation
with open("output.csv", "a") as file:
    while ongoing:
        for i in range(n): 
            for j in range(n):
                infectiousNeighborGrid[i][j] = neighborCheck(i,j)
                determineLatency(i,j)
                determineInfectious(i,j)
                determineRecovered(i,j)
                updateStatusDaysGrid(i,j)
                
            # Write grid to output.csv
                file.write(str(grid[i][j]) + ",")
            file.write("\n")
            if i % n == lineBreakMod:
                file.write("\n")
        
        # Check to see if people are still latent or infectious
        ongoing = stillHappening()