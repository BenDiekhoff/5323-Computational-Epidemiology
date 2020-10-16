turtles-own [susceptible latent infectious recovered latent-ticks infectious-ticks]

;; sets up the simulation
to initialize
  clear-all
  setup-turtles
  reset-ticks
end

;;begins the simulation
to start
  if not any? turtles with [infectious = 1] and not any? turtles with [latent = 1] [stop]
  move-turtles
  latent-check
  infectious-check
  recovered-check
  latent-tick-up
  infectious-tick-up
  tick
end

;;creates the susceptible and infected agents on the board
to setup-turtles
  create-turtles agents - init-infected [ setxy random-xcor random-ycor set color green set susceptible 1]
  create-turtles init-infected [ setxy random-xcor random-ycor set color red set infectious 1
    set infectious-ticks 0]
end

;;randomly moves the agents on the board
to move-turtles
  ask turtles [
    right random 360
    forward 1
  ]
end

;;if a susceptible agent and an infectious agent share the same patch, the susceptible agent becomes infected
;; and is considered latent, as long as a randomly generated number is less than beta
to latent-check
  ask turtles [
    if any? other turtles-here with [color = red] and random-float 1 < beta [
      ask turtles-here with [color = green] [
        set color yellow set susceptible 0 set latent 1 set latent-ticks 0
      ]
    ]
  ]
end

;; if a latent agent has been latent for a user-defined amount of days, it becomes infectious
to infectious-check
  ask turtles with [latent-ticks = days-latent] [
    set color red set latent 0 set infectious 1 set latent-ticks 0 set infectious-ticks 0
  ]
end

;; if an infectious agent has beem infectious for a user-defined amount of days, it stops being
;; infectious and becomes recovered
to recovered-check
  ask turtles with [infectious-ticks = days-infectious] [
    set color blue set infectious 0 set recovered 1 set infectious-ticks 0
  ]
end

;; increments the amount of ticks an agent has been latent for
to latent-tick-up
  ask turtles with [color = yellow] [
    set latent-ticks latent-ticks + 1
  ]
end

;; increments the amount of ticks an agent has been infectious for
to infectious-tick-up
  ask turtles with [color = red] [
    set infectious-ticks infectious-ticks + 1
  ]
end
@#$#@#$#@
GRAPHICS-WINDOW
210
10
647
448
-1
-1
13.0
1
10
1
1
1
0
1
1
1
-16
16
-16
16
1
1
1
ticks
30.0

BUTTON
7
17
88
50
initialize
initialize
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

SLIDER
14
72
186
105
agents
agents
1
200
200.0
1
1
NIL
HORIZONTAL

SLIDER
15
111
187
144
init-infected
init-infected
1
5
5.0
1
1
NIL
HORIZONTAL

SLIDER
14
153
186
186
days-latent
days-latent
1
10
5.0
1
1
NIL
HORIZONTAL

SLIDER
13
195
185
228
days-infectious
days-infectious
1
10
10.0
1
1
NIL
HORIZONTAL

SLIDER
13
233
185
266
beta
beta
0
1
0.50955
.00001
1
NIL
HORIZONTAL

BUTTON
103
17
166
50
start
start
T
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

MONITOR
661
18
735
63
susceptible
count turtles with [susceptible = 1]
0
1
11

MONITOR
659
72
742
117
latent
count turtles with [latent = 1]
0
1
11

MONITOR
661
133
764
178
infectious
count turtles with [infectious = 1]
0
1
11

MONITOR
663
191
733
236
recovered
count turtles with [recovered = 1]
0
1
11

PLOT
6
286
206
436
infectious agents
time
# infectious
0.0
10.0
0.0
10.0
true
false
"" ""
PENS
"default" 1.0 0 -16777216 true "" "plot count turtles with [infectious = 1]"

@#$#@#$#@
Ben Diekhoff
CMPS-5323 Computational Epidemiology
Dr. Johnson
7/20/2020
NetLogo Project 2

## WHAT IS IT?
An agent-based simulation of the SLIR model in which the user can adjust several variables.

## HOW IT WORKS

Agents wander around randomly. If an infectious agent and a susceptible agent share thesame patch, and a randomly generated float is smaller than the beta value, the susceptible agent becomes latent. After a user defined amount of days (ticks), the latent agent becomes infectious. Infectious agents are infectious for a user defines amount of days (ticks), at which point they recover. When there are 0 latent agents and 0 infectious agents left, the simulation stops.

## HOW TO USE IT

- Use the agents slider to determine how many agents you want the simulation to begin with.

- The init-infected slider controls how many of the agents are infected from the beginning of the simulation.

- The days-latent slider determines the amount of ticks before a latent agent becomes infectious.

- The days-infectious slider determines the amount of ticks before an infectious agent stops being infectious and is considered recovered.

- The beta slider determines the transmission rate. If an infected agent and a susceptible agent share the same patch, a random float between 1 and 0 is generated. If the float is less than the beta value, the susceptible agent is infected and becomes latent.

- Press the initialize button to clear the board, reset the ticks, and generate the agents and other settings from the sliders you adjusted.

- To start the simulation, press the start button. You can pause/unpause the simulation by clicking it at any time. 

- The monitors on the right hand side of the board keep track of the number of susceptible, latent, infectious, and recovered agents.

## THINGS TO NOTICE

- Susceptible users are green

- Latent users are yellow

- Infectious users are red

- Recovered users are blue

- Setting days-latent to 5 or higher gives the agents time to spread out to other parts of the population. This is especially noticeable with thousands of agents.

## THINGS TO TRY

- With thousands of users, set the beta slide to be less than 0.25 (mine was 0.19). With 20,000 agents (5 init-infected), 5 day latency, and 1 day of infectiousness, I've had multiple runs where all but 1 or 2 agents were infected! Lucky dogs!!

- With thousands of users, set days-latent to 1 and days-infectious to 10, watch the huge wave of infection. Then set days-latent to 10 and days infections to 1, and watch several small separate waves of infection.

## EXTENDING THE MODEL

Right click on the agents slider, click edit, and change the maximum to 20,000. You can 
do this to modify the number of initially infected agents as well.


## NETLOGO FEATURES

Nothing fancy here!

## RELATED MODELS

- [epiDEM Basic](https://ccl.northwestern.edu/netlogo/models/epiDEMBasic)

- [epiDEM Travel And Control](https://ccl.northwestern.edu/netlogo/models/epiDEMTravelandControl)

- [Spread of Disease](http://ccl.northwestern.edu/netlogo/models/SpreadofDisease)

- [Virus](https://ccl.northwestern.edu/netlogo/models/Virus)

- [Disease Solo](https://ccl.northwestern.edu/netlogo/models/DiseaseSolo)

## CREDITS AND REFERENCES

Much credit goes to the NetLogo tutorials:

- [Tutorial 1](https://ccl.northwestern.edu/netlogo/2.0.0/docs/tutorial1.html)

- [Tutorial 2](https://ccl.northwestern.edu/netlogo/2.0.0/docs/tutorial2.html)

- [Tutorial 3](https://ccl.northwestern.edu/netlogo/2.0.0/docs/tutorial3.html)

Without them, I wouldn't have been able to initialize the simulation, start it, or move the agents!

The Programming Guide and NetLogo Dictionary were invaluable as well:

- [Programming Guide](https://ccl.northwestern.edu/netlogo/docs/programming.html)

- [Dictionary](https://ccl.northwestern.edu/netlogo/docs/dictionary.html)
@#$#@#$#@
default
true
0
Polygon -7500403 true true 150 5 40 250 150 205 260 250

airplane
true
0
Polygon -7500403 true true 150 0 135 15 120 60 120 105 15 165 15 195 120 180 135 240 105 270 120 285 150 270 180 285 210 270 165 240 180 180 285 195 285 165 180 105 180 60 165 15

arrow
true
0
Polygon -7500403 true true 150 0 0 150 105 150 105 293 195 293 195 150 300 150

box
false
0
Polygon -7500403 true true 150 285 285 225 285 75 150 135
Polygon -7500403 true true 150 135 15 75 150 15 285 75
Polygon -7500403 true true 15 75 15 225 150 285 150 135
Line -16777216 false 150 285 150 135
Line -16777216 false 150 135 15 75
Line -16777216 false 150 135 285 75

bug
true
0
Circle -7500403 true true 96 182 108
Circle -7500403 true true 110 127 80
Circle -7500403 true true 110 75 80
Line -7500403 true 150 100 80 30
Line -7500403 true 150 100 220 30

butterfly
true
0
Polygon -7500403 true true 150 165 209 199 225 225 225 255 195 270 165 255 150 240
Polygon -7500403 true true 150 165 89 198 75 225 75 255 105 270 135 255 150 240
Polygon -7500403 true true 139 148 100 105 55 90 25 90 10 105 10 135 25 180 40 195 85 194 139 163
Polygon -7500403 true true 162 150 200 105 245 90 275 90 290 105 290 135 275 180 260 195 215 195 162 165
Polygon -16777216 true false 150 255 135 225 120 150 135 120 150 105 165 120 180 150 165 225
Circle -16777216 true false 135 90 30
Line -16777216 false 150 105 195 60
Line -16777216 false 150 105 105 60

car
false
0
Polygon -7500403 true true 300 180 279 164 261 144 240 135 226 132 213 106 203 84 185 63 159 50 135 50 75 60 0 150 0 165 0 225 300 225 300 180
Circle -16777216 true false 180 180 90
Circle -16777216 true false 30 180 90
Polygon -16777216 true false 162 80 132 78 134 135 209 135 194 105 189 96 180 89
Circle -7500403 true true 47 195 58
Circle -7500403 true true 195 195 58

circle
false
0
Circle -7500403 true true 0 0 300

circle 2
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240

cow
false
0
Polygon -7500403 true true 200 193 197 249 179 249 177 196 166 187 140 189 93 191 78 179 72 211 49 209 48 181 37 149 25 120 25 89 45 72 103 84 179 75 198 76 252 64 272 81 293 103 285 121 255 121 242 118 224 167
Polygon -7500403 true true 73 210 86 251 62 249 48 208
Polygon -7500403 true true 25 114 16 195 9 204 23 213 25 200 39 123

cylinder
false
0
Circle -7500403 true true 0 0 300

dot
false
0
Circle -7500403 true true 90 90 120

face happy
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 255 90 239 62 213 47 191 67 179 90 203 109 218 150 225 192 218 210 203 227 181 251 194 236 217 212 240

face neutral
false
0
Circle -7500403 true true 8 7 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Rectangle -16777216 true false 60 195 240 225

face sad
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 168 90 184 62 210 47 232 67 244 90 220 109 205 150 198 192 205 210 220 227 242 251 229 236 206 212 183

fish
false
0
Polygon -1 true false 44 131 21 87 15 86 0 120 15 150 0 180 13 214 20 212 45 166
Polygon -1 true false 135 195 119 235 95 218 76 210 46 204 60 165
Polygon -1 true false 75 45 83 77 71 103 86 114 166 78 135 60
Polygon -7500403 true true 30 136 151 77 226 81 280 119 292 146 292 160 287 170 270 195 195 210 151 212 30 166
Circle -16777216 true false 215 106 30

flag
false
0
Rectangle -7500403 true true 60 15 75 300
Polygon -7500403 true true 90 150 270 90 90 30
Line -7500403 true 75 135 90 135
Line -7500403 true 75 45 90 45

flower
false
0
Polygon -10899396 true false 135 120 165 165 180 210 180 240 150 300 165 300 195 240 195 195 165 135
Circle -7500403 true true 85 132 38
Circle -7500403 true true 130 147 38
Circle -7500403 true true 192 85 38
Circle -7500403 true true 85 40 38
Circle -7500403 true true 177 40 38
Circle -7500403 true true 177 132 38
Circle -7500403 true true 70 85 38
Circle -7500403 true true 130 25 38
Circle -7500403 true true 96 51 108
Circle -16777216 true false 113 68 74
Polygon -10899396 true false 189 233 219 188 249 173 279 188 234 218
Polygon -10899396 true false 180 255 150 210 105 210 75 240 135 240

house
false
0
Rectangle -7500403 true true 45 120 255 285
Rectangle -16777216 true false 120 210 180 285
Polygon -7500403 true true 15 120 150 15 285 120
Line -16777216 false 30 120 270 120

leaf
false
0
Polygon -7500403 true true 150 210 135 195 120 210 60 210 30 195 60 180 60 165 15 135 30 120 15 105 40 104 45 90 60 90 90 105 105 120 120 120 105 60 120 60 135 30 150 15 165 30 180 60 195 60 180 120 195 120 210 105 240 90 255 90 263 104 285 105 270 120 285 135 240 165 240 180 270 195 240 210 180 210 165 195
Polygon -7500403 true true 135 195 135 240 120 255 105 255 105 285 135 285 165 240 165 195

line
true
0
Line -7500403 true 150 0 150 300

line half
true
0
Line -7500403 true 150 0 150 150

pentagon
false
0
Polygon -7500403 true true 150 15 15 120 60 285 240 285 285 120

person
false
0
Circle -7500403 true true 110 5 80
Polygon -7500403 true true 105 90 120 195 90 285 105 300 135 300 150 225 165 300 195 300 210 285 180 195 195 90
Rectangle -7500403 true true 127 79 172 94
Polygon -7500403 true true 195 90 240 150 225 180 165 105
Polygon -7500403 true true 105 90 60 150 75 180 135 105

plant
false
0
Rectangle -7500403 true true 135 90 165 300
Polygon -7500403 true true 135 255 90 210 45 195 75 255 135 285
Polygon -7500403 true true 165 255 210 210 255 195 225 255 165 285
Polygon -7500403 true true 135 180 90 135 45 120 75 180 135 210
Polygon -7500403 true true 165 180 165 210 225 180 255 120 210 135
Polygon -7500403 true true 135 105 90 60 45 45 75 105 135 135
Polygon -7500403 true true 165 105 165 135 225 105 255 45 210 60
Polygon -7500403 true true 135 90 120 45 150 15 180 45 165 90

sheep
false
15
Circle -1 true true 203 65 88
Circle -1 true true 70 65 162
Circle -1 true true 150 105 120
Polygon -7500403 true false 218 120 240 165 255 165 278 120
Circle -7500403 true false 214 72 67
Rectangle -1 true true 164 223 179 298
Polygon -1 true true 45 285 30 285 30 240 15 195 45 210
Circle -1 true true 3 83 150
Rectangle -1 true true 65 221 80 296
Polygon -1 true true 195 285 210 285 210 240 240 210 195 210
Polygon -7500403 true false 276 85 285 105 302 99 294 83
Polygon -7500403 true false 219 85 210 105 193 99 201 83

square
false
0
Rectangle -7500403 true true 30 30 270 270

square 2
false
0
Rectangle -7500403 true true 30 30 270 270
Rectangle -16777216 true false 60 60 240 240

star
false
0
Polygon -7500403 true true 151 1 185 108 298 108 207 175 242 282 151 216 59 282 94 175 3 108 116 108

target
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240
Circle -7500403 true true 60 60 180
Circle -16777216 true false 90 90 120
Circle -7500403 true true 120 120 60

tree
false
0
Circle -7500403 true true 118 3 94
Rectangle -6459832 true false 120 195 180 300
Circle -7500403 true true 65 21 108
Circle -7500403 true true 116 41 127
Circle -7500403 true true 45 90 120
Circle -7500403 true true 104 74 152

triangle
false
0
Polygon -7500403 true true 150 30 15 255 285 255

triangle 2
false
0
Polygon -7500403 true true 150 30 15 255 285 255
Polygon -16777216 true false 151 99 225 223 75 224

truck
false
0
Rectangle -7500403 true true 4 45 195 187
Polygon -7500403 true true 296 193 296 150 259 134 244 104 208 104 207 194
Rectangle -1 true false 195 60 195 105
Polygon -16777216 true false 238 112 252 141 219 141 218 112
Circle -16777216 true false 234 174 42
Rectangle -7500403 true true 181 185 214 194
Circle -16777216 true false 144 174 42
Circle -16777216 true false 24 174 42
Circle -7500403 false true 24 174 42
Circle -7500403 false true 144 174 42
Circle -7500403 false true 234 174 42

turtle
true
0
Polygon -10899396 true false 215 204 240 233 246 254 228 266 215 252 193 210
Polygon -10899396 true false 195 90 225 75 245 75 260 89 269 108 261 124 240 105 225 105 210 105
Polygon -10899396 true false 105 90 75 75 55 75 40 89 31 108 39 124 60 105 75 105 90 105
Polygon -10899396 true false 132 85 134 64 107 51 108 17 150 2 192 18 192 52 169 65 172 87
Polygon -10899396 true false 85 204 60 233 54 254 72 266 85 252 107 210
Polygon -7500403 true true 119 75 179 75 209 101 224 135 220 225 175 261 128 261 81 224 74 135 88 99

wheel
false
0
Circle -7500403 true true 3 3 294
Circle -16777216 true false 30 30 240
Line -7500403 true 150 285 150 15
Line -7500403 true 15 150 285 150
Circle -7500403 true true 120 120 60
Line -7500403 true 216 40 79 269
Line -7500403 true 40 84 269 221
Line -7500403 true 40 216 269 79
Line -7500403 true 84 40 221 269

wolf
false
0
Polygon -16777216 true false 253 133 245 131 245 133
Polygon -7500403 true true 2 194 13 197 30 191 38 193 38 205 20 226 20 257 27 265 38 266 40 260 31 253 31 230 60 206 68 198 75 209 66 228 65 243 82 261 84 268 100 267 103 261 77 239 79 231 100 207 98 196 119 201 143 202 160 195 166 210 172 213 173 238 167 251 160 248 154 265 169 264 178 247 186 240 198 260 200 271 217 271 219 262 207 258 195 230 192 198 210 184 227 164 242 144 259 145 284 151 277 141 293 140 299 134 297 127 273 119 270 105
Polygon -7500403 true true -1 195 14 180 36 166 40 153 53 140 82 131 134 133 159 126 188 115 227 108 236 102 238 98 268 86 269 92 281 87 269 103 269 113

x
false
0
Polygon -7500403 true true 270 75 225 30 30 225 75 270
Polygon -7500403 true true 30 75 75 30 270 225 225 270
@#$#@#$#@
NetLogo 6.1.1
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
default
0.0
-0.2 0 0.0 1.0
0.0 1 1.0 0.0
0.2 0 0.0 1.0
link direction
true
0
Line -7500403 true 150 150 90 180
Line -7500403 true 150 150 210 180
@#$#@#$#@
0
@#$#@#$#@
