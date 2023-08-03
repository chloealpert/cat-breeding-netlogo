breed [cats cat]
cats-own [ear-type age pregnancy-status pregnancy-timer gender partnered]


to setup
  clear-all
  create-cats initial-cats [
    set shape "cat"
    set size 1.5 ;; easier to see
    set age random 600
    set gender ifelse-value (random 100 < percent-female) ["FEMALE"] ["MALE"] ;; gender slider controls female ratio
    set ear-type ifelse-value (random 100 < percent-folds) ["FOLDS"] ["REGULAR"] ;; gender slider controls folds ratio
    ifelse gender = "FEMALE" [
      ifelse ear-type = "REGULAR" [
        set color 125 ;; female cats with regular ears are dark pink
      ] [
        set color 135 ;; female cats with folds ears are light pink
      ]
    ] [
      ifelse ear-type = "REGULAR" [
        set color 95 ;; male cats with regular ears are dark blue
      ] [
        set color 85 ;; male cats with folds ears are light blue
      ]
    ]
    set pregnancy-status false
    set pregnancy-timer 0
    set partnered false
    setxy random-xcor random-ycor
  ]
  reset-ticks
end


to go
  ask cats [
   move                ;; moves cat throughout the world
   increment-age       ;; increases age and decreases pregnancy timer
   death               ;; cats die after a certain age
   encounter           ;; checks if there's another cat on same patch, if so, runs assess-mate
   birth-check         ;; checks if we should give birth and or reset pregnancy eligibility

  ]
  tick
   ask cats [set partnered false]  ;; Reset partnered attribute for the next tick
end

;;  moves cats in the world.
to move
  if random-float 1.0 < 0.1 [ ;; 10% chance to change direction
    right random 360  ;; randomly turn in any direction
  ]
  forward random 6  ;; move forward randomly 5 steps
end


;; increases age by 1, decreases pregnancy-counter by 1.
to increment-age
  set age age + 1
   if pregnancy-timer > 0 [
        set pregnancy-timer pregnancy-timer - 1
      ]
end


;; cats die if they're too old
to death
  if age > 600 [ die ]
end

;; checks if there's another cat on the patch to partner with
to encounter
  let other-cat one-of other cats-here with [not partnered]
  if other-cat != nobody [
    assess-mate other-cat
    set partnered true
    ask other-cat [set partnered true]
  ]
end

;assess suitable of another cat on the patch for breeding
to assess-mate [other-cat]
  if (gender != [gender] of other-cat) and
     ([pregnancy-status] of other-cat = false) and
     (pregnancy-status = false) and
     (age > 20 and age < 300) and
     ([age] of other-cat > 20 and [age] of other-cat < 300)
  [
    pregnancy ; Run the pregnancy procedure if all conditions are true.
  ]
end

;; makes the female pregnancy and sets the countdown timer for birth
to pregnancy
  if gender = "FEMALE" [
      set pregnancy-status true
      set pregnancy-timer 30
    ]
end

; check if we're giving birth
to birth-check
  if pregnancy-timer = 15 [
    birth
  ]
  if pregnancy-timer = 1 [
    set pregnancy-status false
  ]
end


; makes babies
to birth
  hatch random 4 [
    set shape "cat"
    set ear-type ifelse-value (random-float 1.0 < 0.25) ["FOLDS"] ["REGULAR"]
    set gender ifelse-value (random-float 1.0 < 0.5) ["FEMALE"] ["MALE"]
    set pregnancy-status false
    set pregnancy-timer 0
    set age 0
      ifelse gender = "FEMALE" [
      ifelse ear-type = "REGULAR" [
        set color 125 ;; female cats with regular ears are dark pink
      ] [
        set color 135 ;; female cats with folds ears are light pink
      ]
    ] [
      ifelse ear-type = "REGULAR" [
        set color 85 ;; male cats with regular ears are light blue
      ] [
        set color 95 ;; male cats with folds ears are dark blue
      ]
    ]
  ]
end
@#$#@#$#@
GRAPHICS-WINDOW
210
20
579
390
-1
-1
10.94
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
0
0
1
ticks
30.0

SLIDER
20
20
192
53
initial-cats
initial-cats
0
500
296.0
1
1
NIL
HORIZONTAL

SLIDER
20
65
190
98
percent-female
percent-female
0
100
46.0
1
1
NIL
HORIZONTAL

SLIDER
20
113
192
146
percent-folds
percent-folds
0
100
2.0
1
1
NIL
HORIZONTAL

BUTTON
20
160
190
193
NIL
setup
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
20
205
190
238
Go Forever
go
T
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

PLOT
915
15
1115
165
Total Cats
NIL
NIL
0.0
500.0
0.0
500.0
true
false
"" ""
PENS
"default" 1.0 1 -16777216 true "" "plot count cats"

PLOT
625
15
900
165
Folded ears by gender
NIL
NIL
0.0
500.0
0.0
500.0
true
true
"" ""
PENS
"Female Folds" 1.0 0 -2064490 true "" "plot count CATS with [ear-type = \"FOLDS\" and gender = \"FEMALE\"]"
"Male Folds" 1.0 0 -11221820 true "plot count CATS with [ear-type = \"FOLDS\" and gender = \"MALE\"]" "plot count CATS with [ear-type = \"FOLDS\" and gender = \"MALE\"]"
"Male Regular" 1.0 0 -13791810 true "plot count CATS with [ear-type = \"REGULAR\" and gender = \"MALE\"]" "plot count CATS with [ear-type = \"REGULAR\" and gender = \"MALE\"]"
"Female Regular" 1.0 0 -5825686 true "plot count CATS with [ear-type = \"REGULAR\" and gender = \"FEMALE\"]" "plot count CATS with [ear-type = \"REGULAR\" and gender = \"FEMALE\"]"

MONITOR
915
175
1055
220
Total Alive Cats Now
count cats
17
1
11

MONITOR
625
175
732
220
% Female Folds
(count cats with [ear-type = \"FOLDS\" and gender = \"FEMALE\"]) / (count cats) * 100
2
1
11

MONITOR
745
175
842
220
% Male Folds
(count cats with [ear-type = \"FOLDS\" and gender = \"MALE\"]) / (count cats) * 100
2
1
11

MONITOR
625
225
730
270
% Female Regular
(count cats with [ear-type = \"REGULAR\" and gender = \"FEMALE\"]) / (count cats) * 100
2
1
11

MONITOR
745
225
840
270
% Male Regular
(count cats with [ear-type = \"REGULAR\" and gender = \"MALE\"]) / (count cats) * 100
2
1
11

PLOT
625
285
1125
510
# of Pregnancies
NIL
NIL
0.0
10.0
0.0
10.0
true
true
"" ""
PENS
"Total Pregnancies" 1.0 0 -16777216 true "" "plot count cats with [pregnancy-status = true]"
"Folded Ear Pregnancies" 1.0 0 -2064490 true "" "plot count cats with [pregnancy-status = true and ear-type = \"FOLDS\"]"
"Regular Ear Pregnancies" 1.0 0 -5825686 true "" "plot count cats with [pregnancy-status = true and ear-type = \"REGULAR\"]"

BUTTON
20
240
190
273
Go Once
go
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

@#$#@#$#@
## WHAT IS IT?

	Scope of the model

The Folded Ear Model simulates a population of cats, each characterized by unique attributes such as gender, age, ear type, and pregnancy status. At setup, cats are randomly generated and placed within the simulation area, with the initial number, gender ratio, and the proportion of cats with 'fold' ears adjustable via sliders. The simulation progresses in ticks, during which cats move randomly, age, possibly die, encounter potential mates, and can give birth to a new generation of cats if conditions are met. The encounter procedure involves cats assessing a potential mate's suitability based on their age, pregnancy status, and gender. Finally, if a female cat becomes pregnant, it will eventually give birth to a litter of kittens, whose attributes are determined at birth.

## HOW IT WORKS

	Agent actions / Order of events


-1. Initialization/setup: Creates the initial population(#) of cats, assigning each cat a random age between 0-599, a gender based on the slider, and an ear-type based on the slider. called by "setup" The color of the cats is determined based on their gender and ear type.

-2. go once or go forever: (Go moved the movel forward one step, go forever runs continuously until stopped) Start running the simulation in ticks. It runs the following define procedures in order; move, increment-age, death, encounter, birth-check. For each tick:, partnered status is reset and the rest of the steps as follows:

-3. move: cats randomly move forward up to 5 steps, have a 10% chance of turning direction, and can pick a random direction out of 360 degrees.

-4. increment-age: all cats increase their age by 1 tick (represents a day) and any active pregnancy-timers are decreased by 1. 

-5. death: all cats who are older than 600 ticks are asked to die. (with more computing power this can be changed to more accurately reflect the real-world).

-6. encounter: checks if another cat is on the same patch, and picks it to partner with. A cat can only be partnered with one other cat per turn, and then the assess-mate procedure is run.

-7. assess-mate: checks if both cats are opposite genders, if they are both not pregnant, and if they are both of eligible breeding age (between 20-300 ticks in this model) If all criteria is successfully passed, then pregnancy procedure is triggered.

-8. pregnancy: pregnancy checks if the gender is female, if true, the pregnancy-status is changed to true, and the pregnancy-timer is set to 30.

-9. pregnancy-timer:- if the timer = 15, then the birth procedure is run. if the timer = 1, then the pregnancy-status is set to false. 

-10. birth: hatches a random number of offspring (hatch random 4, so it's between 0-3) with assigned attributes. Hatched chats have a 50% chance of being male or female, and a  25% chance of having folded ears while the rest will have regular ears.

-11. repeat: runs the simulation until halted. 


	Agent types & properties

There are four agent types;
-Females cats with folded ears (light pink)
-Female cats with regular ears (dark pink)
-Male cats with folded ears (light blue)
-Male cats with regular ears (dark blue)

-age: 0-600
-gender: (MALE or FEMALE)
-ear-type: (FOLDS or REGULARS)
-pregnancy-status: (TRUE or FALSE)
-pregnancy-timer: (30 and counts down to 0)


This model does not account for resources, diseases, or predators. It is a simple simulation focusing on the life cycle and reproductive behaviors of a population of cats.


	Environment of the model


The environment in which the cats' movement is bounded by the edges of the space; when a cat reaches an edge, it appears on the opposite edge. This makes the environment behave like a toroidal space allowing the cats to roam endlessly without getting stuck at the boundaries .There are no explicit environmental features like food, obstacles, shelters, or territories coded into this model. It simply provides a space where cats can move, interact with each other based on their proximity (same patch), age, breed, and pregnancy status.

## HOW TO USE IT

	Inputs of the model

-initial-cats slider: This allows you to decide how many cats are in your starting population when you SETUP the model. 

-percent-female slider:** This allows you to decide what percentage of the population is female, with the rest defaulting to male on setup. This can be seen by the color distribution.

-percent-folds slider:** this decides what % of the population has the folds trait, which only has a 25% chance of being passed on to hatched offspring.

	Running the model
-go forever: this allows you to run the model continuously until you press go forever again to stop the model. 

-go once: this allows you to progress the model one tick at a time so you can more closely monitor changes over time. This is particularly useful in exponential outcomes. 

	Outputs of the model
-Folded Ears by Gender Plot: this shows the number of cats alive by gender and by genetic traite, those being; 
-female-folds (light pink)
-male-folds (light blue)
-male-regular (dark-blue)
-female-regular (dark-pink). 

-% Female Folds Monitor: Females with folded ears as a % of total population

-% Female Regular Monior: Females with regular ears as a % of total population

-% Male Folds Monitor: Males with folded ears as a % of total population

-% Male Regular Monitor: Males with regular ears as a % of total population

-Total Cats Plot: aisual representation of the number of total cats alive at a given point in time/tick. Nnot cumulative.

-Total Alive Cats Now Monitor: the exact number of total cats alive at a given point in time/tick. Not cumulative. 

-# of Pregnancies at a given point in time, divided by genetic type, which include;
-Total pregnancies (regular+folds)
-Folded ear pregnancies
-Regular ear pregnancies


## THINGS TO NOTICE

-Population Dynamics: Notice how the population of cats changes over time. Depending on the parameters you set, you may observe periods of population growth, steady state, or decline.

-Gender and Ear Type Distribution:** Watch how the distribution of genders and ear types evolve across generations, especially if you start with uneven ratios.

-Color Coding: The color of each cat indicates its gender and ear type. Use this visual cue to understand the demographics of the cat population at a glance.

-Pregnancy and Birth Rates: Observe how often cats are becoming pregnant and giving birth. These rates are directly related to the population growth and can provide insights into future trends.

-Effects of Adjusting Sliders: Adjust the initial parameters such as the initial number of cats, gender ratio, and the percentage of cats with 'fold' ears, and observe how these changes affect the simulation results. This can help you understand how different factors influence the population dynamics.



## THINGS TO TRY

-Try different starting populations. Some grow faster than others. 

-Try starting with very few females or very few males and see if the population can survive with different gender rations. 

-Try starting with very low numbers of folds and see if you can get the recessive trait to survive. 


## EXTENDING THE MODEL

To extend this model, consider adding food resources, which cats need for survival. Territories could also be added, influencing mating behaviors. Diseases can be incorporated to affect survival and fertility rates, spreading when cats interact. Another extension could be adding predators as agents that hunt cats, increasing cat mortality rates and potentially influencing cat behaviors like grouping or seeking shelter. These additions would enrich the simulation and allow for more complex ecological studies.

With more computing power, we can update our numbers to reflect real-world data. Cats typically reach fertility between six months and seven years of age, with a gestation period lasting 65 days, and usually birth a maximum of three litters per year. Their lifespan generally ranges from 12 to 16 years. These real-world cat parameters could be integrated into the model to enhance its fidelity to actual feline behavior and life cycles.

## NETLOGO FEATURES

-in the code tab, try changing the lifespan of the cats (in the 'death' proceedure) cats will live longer and product different results

-also in the code tab under pregnancy and birth-check, you can change the duration of a pregnancy. 


## RELATED MODELS

-Simple Birth Rates: this model shares birth rate dynamics with this model, and might be of interest in ways to extend th emodel. 

-Bird Breeder** introduces a revenue component to breeding which could be interesting to someone builing a model who is trying to breed a specific trait into their population for profit. 

## CREDITS AND REFERENCES

Anonymous for the purposes of peer review.
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

cat
false
0
Line -7500403 true 285 240 210 240
Line -7500403 true 195 300 165 255
Line -7500403 true 15 240 90 240
Line -7500403 true 285 285 195 240
Line -7500403 true 105 300 135 255
Line -16777216 false 150 270 150 285
Line -16777216 false 15 75 15 120
Polygon -7500403 true true 300 15 285 30 255 30 225 75 195 60 255 15
Polygon -7500403 true true 285 135 210 135 180 150 180 45 285 90
Polygon -7500403 true true 120 45 120 210 180 210 180 45
Polygon -7500403 true true 180 195 165 300 240 285 255 225 285 195
Polygon -7500403 true true 180 225 195 285 165 300 150 300 150 255 165 225
Polygon -7500403 true true 195 195 195 165 225 150 255 135 285 135 285 195
Polygon -7500403 true true 15 135 90 135 120 150 120 45 15 90
Polygon -7500403 true true 120 195 135 300 60 285 45 225 15 195
Polygon -7500403 true true 120 225 105 285 135 300 150 300 150 255 135 225
Polygon -7500403 true true 105 195 105 165 75 150 45 135 15 135 15 195
Polygon -7500403 true true 285 120 270 90 285 15 300 15
Line -7500403 true 15 285 105 240
Polygon -7500403 true true 15 120 30 90 15 15 0 15
Polygon -7500403 true true 0 15 15 30 45 30 75 75 105 60 45 15
Line -16777216 false 164 262 209 262
Line -16777216 false 223 231 208 261
Line -16777216 false 136 262 91 262
Line -16777216 false 77 231 92 261

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
NetLogo 6.3.0
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
<experiments>
  <experiment name="experiment" repetitions="10000" runMetricsEveryStep="true">
    <setup>setup</setup>
    <go>go</go>
    <metric>count turtles</metric>
    <enumeratedValueSet variable="female-ratio">
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="initial-cats">
      <value value="223"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="ear-type-ratio">
      <value value="0.4"/>
    </enumeratedValueSet>
  </experiment>
</experiments>
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
1
@#$#@#$#@
