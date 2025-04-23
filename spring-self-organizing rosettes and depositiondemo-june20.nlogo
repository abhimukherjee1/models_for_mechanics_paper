globals  [ turnover ]
turtles-own [my-Radius fgf]
patches-own [secreted-fgf ]
breed [ depositer depositers ]
breed [ wnter wnters ]
breed [ FGFer FGFers ]


to setup
  clear-all
 ask patches
 [ if abs pycor < pllp-width and pxcor < ((-1 * max-pxcor) + pllp-length )
 [ sprout 1 ]]
 ask turtles
 [set color red
  set size 0.5  ;; easier to see
  set shape "circle"]
 ask patches [set pcolor black ]
  set fgf-size pllp-length
  set wnt-size pllp-length * Wnt-fraction
  reset-ticks
end


to set-breeds
  ask turtles
  [ if xcor > max [xcor ] of turtles - Wnt-size
     [set breed Wnter
      set size 0.5
      set color green
      set shape "circle" ]
  ;
    if ( xcor >= max [xcor ] of turtles - Fgf-size  ) and ( xcor <= max [xcor ] of turtles - Wnt-size ) [set breed fgfer set shape "circle" set color yellow ]
    if  xcor < max [xcor ] of turtles - fgf-size [set breed depositer set shape "circle" set color red ]

]

end



to shrink-Wnt-domain

  if ( (ticks mod shrink-cycle ) = 0 ) and ( wnt-size >= 0 )
[
  set fgf-size (fgf-size - 1)
  Set wnt-size ( fgf-size * Wnt-fraction)
 ]
end

to go
set-breeds

ask Wnter
  [ if ticks > migration-delay [set heading 90 fd speed ]

    ask my-links [ if link-length > Wnt-break-threshold * wnt-spring-length [ die ]]
    if random 100 < wnt-turnover [ ask my-links [die]]

    create-links-with other turtles in-radius wnt-radius
    repeat 1 [ layout-spring link-neighbors my-links Wnt-spring-constant Wnt-spring-length Wnt-repulsion-constant ]

    if show-density?  [ set color scale-color red  ( count turtles in-radius 3 ) 0 density-scale if count turtles in-radius 3 > cluster-threshold [set color cyan]]
    ;if show-identity? [ set color who  ]
  ]
    ask Fgfer
  [
    ask my-links [ if link-length > fgf-break-threshold * fgf-spring-length [ die ]]
    if random 100 < fgf-turnover [ ask my-links [die]]

     create-links-with other turtles in-radius fgf-radius
    repeat 1 [ layout-spring link-neighbors my-links fgf-spring-constant fgf-spring-length fgf-repulsion-constant ]

if show-density?  [ set color scale-color red  ( count turtles in-radius 3 ) 0 density-scale if count turtles in-radius 3 > cluster-threshold [set color cyan]]
;if show-identity? [ set color who ]
  ]


ask depositer
 [
     ask my-links [ if link-length > depositer-break-threshold * depositer-spring-length [ die ]]
     if random 100 < depositer-turnover [ ask my-links [die]]

    create-links-with other turtles in-radius FGF-radius
    repeat 1 [ layout-spring link-neighbors my-links depositer-spring-constant depositer-spring-length depositer-repulsion-constant ]

if show-density?  [ set color scale-color red  ( count turtles in-radius 3 ) 0 density-scale  if count turtles in-radius 3 > cluster-threshold [set color cyan]]


;if show-identity? [ set color who ]
  ]


if wnter-proliferate? = true
[ if count wnter > 0
 [ ask one-of wnter
 [ if ( random 100  / 1000 ) < proliferation-rate [ hatch-wnter 1 [set color blue set ycor 0 set shape "circle"] ]]

 ]]
;if ticks > migration-delay [ leader-migration ]
if shrink-wnt-zone = true [ shrink-Wnt-domain ]

 if fgfer-proliferate? [ if count fgfer > 0
  [ ask one-of fgfer
  [ if ( random 100  / 1000 ) < proliferation-rate [ hatch-fgfer 1 [set color blue set ycor 0 set shape "circle"] ]]
 ]
 ]
  tick


end
@#$#@#$#@
GRAPHICS-WINDOW
11
10
1315
99
-1
-1
16.0
1
10
1
1
1
0
0
0
1
-40
40
-2
2
1
1
1
ticks
30.0

BUTTON
1246
387
1309
420
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
1345
386
1487
419
NIL
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

SLIDER
688
279
871
312
FGF-spring-constant
FGF-spring-constant
.01
1
0.07
.01
1
NIL
HORIZONTAL

SLIDER
688
315
871
348
FGF-spring-length
FGF-spring-length
0
1
0.5
.1
1
NIL
HORIZONTAL

SLIDER
688
351
875
384
FGF-repulsion-constant
FGF-repulsion-constant
0
0.1
0.005
.001
1
NIL
HORIZONTAL

SLIDER
389
140
561
173
speed
speed
0
1
0.05
.01
1
NIL
HORIZONTAL

SLIDER
492
482
679
515
Wnt-turnover
Wnt-turnover
0
100
0.0
1
1
NIL
HORIZONTAL

SLIDER
783
140
890
173
pllp-width
pllp-width
0
7
3.0
1
1
NIL
HORIZONTAL

SLIDER
905
141
1014
174
pllp-length
pllp-length
1
100
30.0
1
1
NIL
HORIZONTAL

SLIDER
208
314
380
347
shrink-cycle
shrink-cycle
1
1000
90.0
1
1
NIL
HORIZONTAL

SLIDER
571
142
743
175
migration-delay
migration-delay
0
2000
0.0
1
1
NIL
HORIZONTAL

MONITOR
788
184
876
229
total pllp cells
count turtles
0
1
11

SWITCH
20
314
195
347
shrink-wnt-zone
shrink-wnt-zone
0
1
-1000

TEXTBOX
71
242
428
272
Set Wnt /FGF zone by relative size or manual control\n
12
0.0
1

TEXTBOX
518
115
668
133
MIGRATION SETTINGS
12
0.0
1

TEXTBOX
1222
111
1464
335
INSTRUCTIONS\nTo see movement based on asymmetric radius of capture to make links\nKeep all spring p -arameters constant. Set speed to 0\n1. Set Wnt-radius 4.0 and FGF-radius, depositer-radius 4.0\nThere should be no movement.\n2. Then set Wnt-radius 5.0 \nmovement should start\n3. Try increasing a fgf-break threshold.\nmovement should stop\n4. Increase fgf turnover \nmovement will resume.\nPlay with parameters to see how it influences behavior
11
0.0
1

SLIDER
285
273
413
306
fgf-size
fgf-size
0
pllp-length
21.0
1
1
NIL
HORIZONTAL

SLIDER
161
273
277
306
Wnt-size
Wnt-size
0
100
12.6
1
1
NIL
HORIZONTAL

SLIDER
901
484
1109
517
depositer-turnover
depositer-turnover
0
100
0.0
.1
1
NIL
HORIZONTAL

SLIDER
20
443
137
476
Wnt-radius
Wnt-radius
0
10
2.0
.1
1
NIL
HORIZONTAL

SLIDER
275
445
408
478
depositer-radius
depositer-radius
0
10
2.0
.1
1
NIL
HORIZONTAL

SLIDER
488
279
672
312
Wnt-spring-constant
Wnt-spring-constant
0
1
0.07
.01
1
NIL
HORIZONTAL

SLIDER
488
316
672
349
Wnt-spring-length
Wnt-spring-length
0
1
0.5
.1
1
NIL
HORIZONTAL

SLIDER
483
352
673
385
Wnt-repulsion-constant
Wnt-repulsion-constant
0
0.1
0.007
.001
1
NIL
HORIZONTAL

SLIDER
696
482
884
515
FGF-turnover
FGF-turnover
0
100
0.0
.1
1
NIL
HORIZONTAL

SLIDER
144
444
270
477
FGF-radius
FGF-radius
0
10
2.0
.1
1
NIL
HORIZONTAL

SLIDER
894
279
1095
312
depositer-spring-constant
depositer-spring-constant
0
1
0.06
.01
1
NIL
HORIZONTAL

SLIDER
894
316
1096
349
depositer-spring-length
depositer-spring-length
0
1
0.5
.1
1
NIL
HORIZONTAL

SLIDER
893
352
1099
385
Depositer-repulsion-constant
Depositer-repulsion-constant
0
0.1
0.005
.001
1
NIL
HORIZONTAL

SLIDER
1028
139
1200
172
proliferation-rate
proliferation-rate
0
.01
0.001
.0001
1
NIL
HORIZONTAL

SLIDER
25
272
153
305
Wnt-fraction
Wnt-fraction
0
1
0.6
.10
1
NIL
HORIZONTAL

SWITCH
51
138
198
171
show-density?
show-density?
0
1
-1000

SWITCH
1044
191
1192
224
wnter-proliferate?
wnter-proliferate?
0
1
-1000

BUTTON
1278
459
1386
492
make-movie
ifelse ticks < 800\n\n[\n\nexport-view (word \"self-organizing ZO1 demo speed-05 celltype\" ticks \".png\")\ngo\n]\n\n\n[ stop ]
T
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

SLIDER
697
444
883
477
fgf-break-threshold
fgf-break-threshold
1
300
52.0
1
1
NIL
HORIZONTAL

SLIDER
899
444
1108
477
Depositer-break-threshold
Depositer-break-threshold
1
300
1.0
1
1
NIL
HORIZONTAL

SLIDER
491
443
679
476
wnt-break-threshold
wnt-break-threshold
1
300
52.0
1
1
NIL
HORIZONTAL

SWITCH
889
190
1030
223
fgfer-proliferate?
fgfer-proliferate?
0
1
-1000

SLIDER
205
139
353
172
density-scale
density-scale
0
100
54.0
1
1
NIL
HORIZONTAL

TEXTBOX
853
114
1116
142
INITIAL PRIMORDIUM SIZE AND GROWTH RATE
11
0.0
1

TEXTBOX
5
116
381
144
Choose display to see cell type or cell density based on density scale
11
0.0
1

TEXTBOX
605
253
1017
283
LINK (SPRING) PARAMETERS for WNTer FGFer and Depositer cell types
11
0.0
1

TEXTBOX
77
412
380
430
RADIUS OF CAPTURE BY LINKS OF NEIGHBORING CELLS
11
0.0
1

TEXTBOX
616
421
958
440
LINK (SPRING) turnover and break threshold for each cell type
11
0.0
1

TEXTBOX
47
182
375
200
Types of cells: WNTer (Green) FGFer (yellow) Depositer (red)
11
0.0
1

TEXTBOX
400
181
551
209
WNTers move forward \"speed\" units each iteration
11
0.0
1

TEXTBOX
65
358
352
385
If Wnt-shrink-zone ON, Wnt zone shrinks at rate determined by shrink-cycle
11
0.0
1

SLIDER
105
497
278
530
cluster-threshold
cluster-threshold
0
100
73.0
1
1
NIL
HORIZONTAL

@#$#@#$#@
## WHAT IS IT?

This is a model to explore the formation and deposition of neuromast by the migrating lateral line prinordium

## HOW IT WORKS

The model works in the following way
1.       There are three types of cells each represented by different “breeds” of “turtles” , WNTers (green), FGFers (yellow), Depositers (red), which represent cells in a leading Wnt, FGF and trailing depositing zone, respectively.
2.       To initialize a primordium of defined size: seed a rectangular grid of  turtles “pllp-width” wide and “pllp-length” long set with sliders in the interface and press SETUP.
3.       Then based on “Wnt-fraction” the pllp turtles are assigned “breeds” , a leading compartment of WNTers, trailing compartment of FGFers. The size of these compartments can also be set manually by sliders.
4.       The number of WNTers and FGFers can increase based on a rate of proliferation which can be adjusted with a slide in the interface.
5.       Each cell type, Wnter, FGFer and Depositer, has the potential to make links or spring-like connections with neighbors within a distance defined by Wnt-radius, FGF-radius, and Depositer-radius respectively
6.       The spring parameters: spring-constant, length-constant and repulsion-constant, can be set differently in the program interface for each breed type.
7.       Springs/links break if their length exceeds some threshold or based on set turnover rate.
8.       Only WNTers have the potential to move on their own. At each iteration of the program, each WNTer keeps its heading to the right and moves forward “speed” patches
9.       The movement of trailing FGFers and Depositers is determined by mechanical coupling with” links”, they have no independent capacity to move.


## HOW TO USE IT

(how to use the model, including a description of each of the items in the Interface tab)

## THINGS TO NOTICE

(suggested things for the user to notice while running the model)

## THINGS TO TRY

(suggested things for the user to try to do (move sliders, switches, etc.) with the model)

## EXTENDING THE MODEL

(suggested things to add or change in the Code tab to make the model more complicated, detailed, accurate, etc.)

## NETLOGO FEATURES

(interesting or unusual features of NetLogo that the model uses, particularly in the Code tab; or where workarounds were needed for missing features)

## RELATED MODELS

(models in the NetLogo Models Library and elsewhere which are of related interest)

## CREDITS AND REFERENCES

(a reference to the model's URL on the web if it has one, as well as any other necessary credits, citations, and links)
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

circle 3
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 75 75 150

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

hex
false
0
Polygon -7500403 true true 0 150 75 30 225 30 300 150 225 270 75 270

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
NetLogo 6.4.0
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
