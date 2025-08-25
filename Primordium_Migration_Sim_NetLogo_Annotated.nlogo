breed [wnters wnter] ;Leading wnt zone cells
breed [fgfers fgfer] ;Trailing fgf zone cells
breed [depositers depositer] ;Deposited cells


to startup ;Startup procedure is automatically run when the model is opened
  setup
end

to setup ;Setup resets the simulation and prepares it to be run

  clear-all
  set-default-shape turtles cell-shape
  ask patches [
    if abs pycor < pllp-width and pxcor < ((-1 * max-pxcor) + pllp-length) [sprout 1] ;Spawns turtles in a rectangle with set proportions
  ]
  ask patches [set pcolor black]
  set fgf-size pllp-length
  set wnt-size pllp-length * wnt-fraction
  set-breeds
  ask wnters [ ;Only turtles with the breed "wnters" follow these commands
    create-links-with other turtles in-radius wnt-radius ;Wnter turtle creates links with turtles that are less than or equal to a set distance
    color-turtles
  ]
  ask fgfers [ ;Only turtles with the breed "fgfers" follow these commands
    create-links-with other turtles in-radius fgf-radius ;Fgfer turtle creates links with turtles that are less than or equal to a set distance
    color-turtles
  ]
  ask depositers [ ;Only turtles with the breed "depositers" follow these commands
    create-links-with other turtles in-radius depositer-radius ;Depositer turtle creates links with turtles that are less than or equal to a set distance
    color-turtles
  ]
  ask links [set color grey]
  reset-ticks

end


to set-breeds ;Sets the breeds of the turtles based on their location and sizes of wnt/fgf zones

  ask turtles [
    if xcor > max [xcor] of turtles - wnt-size [
      set breed wnters ;sets leading zone turtles breed to wnter
      color-turtles
    ]
    if (xcor >= max [xcor] of turtles - fgf-size) and (xcor <= max [xcor] of turtles - wnt-size) [
      set breed fgfers ;sets trailing zone turtles breed to fgfer
      color-turtles
    ]
    if xcor < max [xcor] of turtles - fgf-size [
      set breed depositers ;sets deposited cells to depositers
      color-turtles
  ]]

end



to shrink-wnt-domain ;Shrinks the size of the leading wnt zone at a set rate

  if ((ticks mod shrink-cycle) = 0) and (wnt-size >= 0) [
    set fgf-size (fgf-size - 1)
    set wnt-size (fgf-size * wnt-fraction)
  ]

end

to color-turtles ;Colors the turtles based on their breeds or density

  set size cell-size
  ifelse show-density? [
    set color scale-color red (count turtles in-radius 3) 0 density-scale ;Density is measured by counting the number of turtles within 3 units of this turtle
      if count turtles in-radius 3 > cluster-threshold [set color cyan]
  ][
    if breed = wnters [
      set color green
    ]
  if breed = fgfers [
      set color yellow
    ]
  if breed = depositers [
      set color red
  ]]

end

to go ;When the "go" button is pushed on the interface, is procedure is run repeatedly until the button is pressed again
      ;to run this code only once, press "go one step"
  set-breeds
  ask wnters [
    if ticks > migration-delay [
      set heading 90 ;sets the wnter forward direction to the right
        fd cxcl12a-speed ;moves wnter forward by set amount
    ]
    ask my-links [
      if link-length > wnt-break-threshold * wnt-spring-length [die] ;Breaks links if they stretch too far
    ]
    if random 100 < wnt-turnover [
      ask my-links [die] ;Randomly breaks links
    ]
    create-links-with other turtles in-radius wnt-radius
    layout-spring link-neighbors my-links Wnt-spring-constant Wnt-spring-length Wnt-repulsion-constant ;Arranges the turtles that are linked to this turtle as if their links are springs with the set variables
    color-turtles
  ]

  ask fgfers [
    if ticks > migration-delay [
      set heading 90 ;sets the fgfer forward direction to the right
      fd fgf-speed ;moves fgfer forward by set amount
    ]
    ask my-links [
      if link-length > fgf-break-threshold * fgf-spring-length [die] ;Breaks links if they stretch too far
    ]
    if random 100 < fgf-turnover [
      ask my-links [die] ;Randomly breaks links
    ]
    create-links-with other turtles in-radius fgf-radius
    layout-spring link-neighbors my-links fgf-spring-constant fgf-spring-length fgf-repulsion-constant ;Arranges the turtles that are linked to this turtle as if their links are springs with the set variables
    color-turtles
  ]

  ask depositers [
    ask my-links [
      if link-length > depositer-break-threshold * depositer-spring-length [die] ;Breaks links if they stretch too far
    ]
    if random 100 < depositer-turnover [
      ask my-links [die] ;Randomly breaks links
    ]
    create-links-with other turtles in-radius depositer-radius
    layout-spring link-neighbors my-links depositer-spring-constant depositer-spring-length depositer-repulsion-constant ;Arranges the turtles that are linked to this turtle as if their links are springs with the set variables
    color-turtles
  ]

  ask links [set color grey] ;Recolors new links to be grey

  if wnter-proliferate? [
    if count wnters > 0 [
      ask one-of wnters [
        if (random 100 / 1000) < proliferation-rate [
          hatch-wnters 1 [set ycor 0] ;Creates a new wnter turtle
  ]]]]

  if shrink-wnt-zone = true [shrink-wnt-domain]

  if fgfer-proliferate? [
    if count fgfers > 0 [
      ask one-of fgfers [
        if ( random 100  / 1000 ) < proliferation-rate [
          hatch-fgfers 1 [set ycor 0] ;Creates a new fgfer turtle
  ]]]]

  tick ;adds 1 to tick counter

end
@#$#@#$#@
GRAPHICS-WINDOW
0
10
1220
151
-1
-1
12.0
1
10
1
1
1
0
0
0
1
-50
50
-5
5
1
1
1
ticks
30.0

BUTTON
5
175
68
208
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
75
175
145
208
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
340
415
505
448
fgf-spring-constant
fgf-spring-constant
.00
1
0.07
.01
1
NIL
HORIZONTAL

SLIDER
340
470
505
503
fgf-spring-length
fgf-spring-length
0
1
0.5
.1
1
NIL
HORIZONTAL

SLIDER
340
525
505
558
fgf-repulsion-constant
fgf-repulsion-constant
0
0.1
0.005
.001
1
NIL
HORIZONTAL

SLIDER
730
270
865
303
cxcl12a-speed
cxcl12a-speed
0
0.1
0.05
.0001
1
NIL
HORIZONTAL

SLIDER
730
490
870
523
wnt-turnover
wnt-turnover
0
100
0.0
1
1
NIL
HORIZONTAL

SLIDER
5
250
97
283
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
100
250
192
283
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
450
290
622
323
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
1000
270
1172
303
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
155
325
240
370
Total Pllp Cells
count turtles
0
1
11

SWITCH
315
290
445
323
shrink-wnt-zone
shrink-wnt-zone
0
1
-1000

TEXTBOX
295
230
435
248
Wnt/Fgf Zone Size Settings\n
11
0.0
1

TEXTBOX
735
250
830
268
Migration Settings
11
0.0
1

SLIDER
540
250
660
283
fgf-size
fgf-size
0
pllp-length
23.0
1
1
NIL
HORIZONTAL

SLIDER
415
250
535
283
wnt-size
wnt-size
0
100
13.799999999999999
1
1
NIL
HORIZONTAL

SLIDER
1015
490
1190
523
depositer-turnover
depositer-turnover
0
100
1.0
1
1
NIL
HORIZONTAL

SLIDER
730
380
870
413
wnt-radius
wnt-radius
0
10
2.0
.01
1
NIL
HORIZONTAL

SLIDER
1015
380
1190
413
depositer-radius
depositer-radius
0
10
2.0
.01
1
NIL
HORIZONTAL

SLIDER
170
415
335
448
wnt-spring-constant
wnt-spring-constant
0
1
0.07
.01
1
NIL
HORIZONTAL

SLIDER
170
470
335
503
wnt-spring-length
wnt-spring-length
0
1
0.5
.1
1
NIL
HORIZONTAL

SLIDER
170
525
335
558
wnt-repulsion-constant
wnt-repulsion-constant
0
0.1
0.007
.001
1
NIL
HORIZONTAL

SLIDER
875
490
1010
523
fgf-turnover
fgf-turnover
0
100
0.0
1
1
NIL
HORIZONTAL

SLIDER
875
380
1010
413
fgf-radius
fgf-radius
0
10
2.0
.01
1
NIL
HORIZONTAL

SLIDER
510
415
705
448
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
510
470
705
503
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
510
525
705
558
depositer-repulsion-constant
depositer-repulsion-constant
0
0.1
0.005
.001
1
NIL
HORIZONTAL

SLIDER
5
325
145
358
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
290
250
410
283
wnt-fraction
wnt-fraction
0
1
0.6
.10
1
NIL
HORIZONTAL

SWITCH
265
175
385
208
show-density?
show-density?
1
1
-1000

SWITCH
5
360
145
393
wnter-proliferate?
wnter-proliferate?
0
1
-1000

SLIDER
875
435
1010
468
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
1015
435
1190
468
depositer-break-threshold
depositer-break-threshold
.01
300
1.0
.01
1
NIL
HORIZONTAL

SLIDER
730
435
870
468
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
5
395
145
428
fgfer-proliferate?
fgfer-proliferate?
0
1
-1000

SLIDER
390
175
510
208
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
270
155
355
173
Display Controls
11
0.0
1

TEXTBOX
740
155
825
211
Cell Type Key: \nWNTer - green\nFGFer - yellow \nDepositer - red
11
0.0
1

TEXTBOX
750
325
970
343
Cells move forward \"speed\" units each tick
11
0.0
1

TEXTBOX
325
330
612
357
When \"shrink-wnt-zone\" is ON, the Wnt zone shrinks after every \"shrink-cycle\" amount of ticks
11
0.0
1

SLIDER
515
175
635
208
cluster-threshold
cluster-threshold
0
100
73.0
1
1
NIL
HORIZONTAL

SLIDER
870
270
993
303
fgf-speed
fgf-speed
0
.1
0.007
.0001
1
NIL
HORIZONTAL

BUTTON
1060
155
1235
188
Figure? settings (no deposition)
;Display Controls\nset show-density? true\nset density-scale 36\nset cluster-threshold 32\nset cell-size 1\nset cell-shape \"hexagon\"\n\n;Inital Primordium Size Settings\nset pllp-width 3\nset pllp-length 30\n\n;Wnt/Fgf Zone Size Settings\nset Wnt-fraction 0.6\nset shrink-wnt-zone false\n\n\n;Migration Settings\nset cxcl12a-speed 0.018\nset fgf-speed 0.016\nset migration-delay 0\n\n;Growth Settings\nset proliferation-rate 0.0005\nset wnter-proliferate? false\nset fgfer-proliferate? false\n\n;Spring-Link Settings\nset Wnt-radius 1.25\nset FGF-radius 1.25\nset depositer-radius 1.25\nset wnt-spring-constant 0.18\nset fgf-spring-constant 0.18\nset depositer-spring-constant 0.08\nset wnt-spring-length 0.1\nset fgf-spring-length 0.1\nset depositer-spring-length 1\nset wnt-repulsion-constant 0.03\nset fgf-repulsion-constant 0.03\nset depositer-repulsion-constant 0.03\nset wnt-break-threshold 300\nset fgf-break-threshold 300\nset depositer-break-threshold 0.1\nset wnt-turnover 1\nset fgf-turnover 1\nset depositer-turnover 1
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
150
175
247
208
go one step
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

TEXTBOX
10
155
110
173
Simulation Controls
11
0.0
1

TEXTBOX
10
230
165
248
Inital Primordium Size Settings
11
0.0
1

TEXTBOX
10
305
90
323
Growth Settings
11
0.0
1

TEXTBOX
175
395
455
421
Spring Settings (treats links as if they were springs)
11
0.0
1

TEXTBOX
830
155
1065
215
Cell Density Key:\nDark red: Low Density\nLight red: High Density\nCyan: Cell meets density of cluster threshold
11
0.0
1

TEXTBOX
180
450
410
468
Resistance to changes in length
11
0.0
1

TEXTBOX
180
505
330
523
Natural length of spring
11
0.0
1

TEXTBOX
180
560
360
578
Cell-Cell repulsion
11
0.0
1

TEXTBOX
740
470
1055
488
Threshold that a link can be stretched before it breaks
11
0.0
1

TEXTBOX
740
525
935
543
Chance of random link breaks
11
0.0
1

TEXTBOX
740
415
1040
433
Distance that cells can make links to one another
11
0.0
1

TEXTBOX
740
360
890
378
Link settings
11
0.0
1

TEXTBOX
735
305
840
323
Speed of Wnter cells
11
0.0
1

TEXTBOX
875
305
975
323
Speed of Fgfer cells
11
0.0
1

BUTTON
1060
195
1235
228
Figure? settings (deposition)
;Display Controls\nset show-density? false\nset density-scale 54\nset cluster-threshold 73\nset cell-size 0.5\nset cell-shape \"circle\"\n\n;Inital Primordium Size Settings\nset pllp-width 3\nset pllp-length 30\n\n;Wnt/Fgf Zone Size Settings\nset Wnt-fraction 0.6\nset shrink-wnt-zone true\nset shrink-cycle 90\n\n;Migration Settings\nset cxcl12a-speed 0.05\nset fgf-speed 0.007\nset migration-delay 0\n\n;Growth Settings\nset proliferation-rate 0.001\nset wnter-proliferate? true\nset fgfer-proliferate? true\n\n;Spring-Link Settings\nset Wnt-radius 2\nset FGF-radius 2\nset depositer-radius 2\nset wnt-spring-constant 0.07\nset fgf-spring-constant 0.07\nset depositer-spring-constant 0.06\nset wnt-spring-length 0.5\nset fgf-spring-length 0.5\nset depositer-spring-length 0.5\nset wnt-repulsion-constant 0.007\nset fgf-repulsion-constant 0.005\nset depositer-repulsion-constant 0.005\nset wnt-break-threshold 52\nset fgf-break-threshold 52\nset depositer-break-threshold 1\nset wnt-turnover 0\nset fgf-turnover 0\nset depositer-turnover 0
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
640
155
732
188
cell-size
cell-size
0
1
0.5
0.1
1
NIL
HORIZONTAL

CHOOSER
640
190
732
235
cell-shape
cell-shape
"circle" "hexagon"
0

INPUTBOX
5
655
75
715
repetitions
0.0
1
0
Number

TEXTBOX
10
610
160
651
Variable to assist with creating movies of simulations: do not touch
11
0.0
1

@#$#@#$#@
## WHAT IS IT?

This model explores the ability of the posterior lateral line primordium (pllp) to form clusters of cells via collective migration and cell adhesion.

## HOW IT WORKS

The cells of the primordium are represented by circular "turtles" and can adhere to other cells using "links". Cells have a "breed" that determine how they act. Wnters (green) represent the cells of the leading Wnt domain. Fgfers (yellow) represent the cells of the trailing Fgf domain. Depositers (red) represent deposited cells.

An inital pllp made up of cells is created when the simulation is set up, its demensions determined by editable variables “pllp-width” and “pllp-length”. The cells are assigned their inital "breeds" based on their location in the primordium, and then create "links" to other cells using parameters dependent on their "breed".

When the simulation is running, cells will move, create and break "links", and have the potential to proliferate. Additionally, "links" between cells are treated as if they were springs, meaning they resist changes in their length. The parameters of these springs are also dependent on their "breed". The display is able to show the "breed" of the cells through their color or the density of the cells.

This simulation is effective in showing how differences in cell adhesion and migration in the primordium changes where and when the primordium forms dense clusters of cells, along with the size and number of clusters.

## HOW TO USE IT	
In this section we will explain the elements present on the interface. Most of these elements can be interacted with. Buttons run a set of commands when clicked, and sliders change the values of variables in the program. Moniters simply display variables and provide information. Switches control boolean variables. Choosers let you select an item from a list.

### SIMULATION CONTROLS
The button "setup" resets the simulation and prepares it to run again. After changing some of the slider variables, it is a good idea to click "setup" again to make sure the new parameters are applied. The button "go" runs the simulation, and continues to run the simulation until it is clicked again. The "go one step" button only runs the simulation once.

### DISPLAY CONTROLS
The "show-density?" switch toggles between cells displaying their density or their breed. When "show-density?" is on, a cell's color is determined by how many cells are within a distance of 3 units. Darker shades of red indicate low density, while lighter tints of red indicate high density. The "density-scale" slider controls what is considered high density. If there is little variation in the color of the cells, this slider is likley set too high or low. The "cluster-threshold" slider sets the density at which cells are marked by cyan. This is intended to highlight cells with high density. If "show-density?" is off, then cells will be colored based on their breed. Wnters are green, Fgfers are yellow, and Depositers are red. Changes to the display controls will not change the display unless the simulation is actively running. The "cell-size" slider changes the visual size of the cells. If the cells are arranged close together, a smaller "cell-size" helps to keep all the individual cells visible. The "cell-shape" chooser lets you change the visual shape of the cells.

### INITAL PRIMORDIUM SIZE SETTINGS
The "pllp-width" slider determines the inital width of the pllp. When setting up the simulation, cells are only created on spaces that have a y cordinate less than the "pllp-width" variable. This means that the true width of the primordium ends up being two more than the "pllp-width" variable. The "pllp-length" slider determines the inital length of the pllp. The true inital length is equal to this variable. Changes to these variables will not affect the simulation until setup is pressed again.  

### WNT/FGF ZONE SIZE SETTINGS
The "wnt-fraction" slider changes the proportion of the pllp that is the leading wnt zone. For example, a "wnt-fraction" of 0.6 creates a primordium where the leading wnt zone makes up 60% of the total primordium. The cells in this zone will have their breeds set to wnters. The sliders "wnt-size" and "fgf-size" set the lengths of the wnt zone and fgf zone. These values are automatically set based off of "wnt-fraction" and "pllp-length" when "setup" is pressed, but these sliders can be changed afterward to affect the simulation mid-run. The "shrink-wnt-zone" switch, when turned on, causes the size of the leading wnt zone to shrink. The rate at which it shrinks is determined by the "shrink-cycle" slider.

### MIGRATION SETTINGS
The "cxcl12a-speed" and "fgf-speed" sliders changes the distance wnter and fgfer cells respectively move forward each tick. In the real system, cells on the leading edge migrate in response to cxcl12a that is secreted along the horizontal myoseptum. The trailing cells migrate towards fgf ligands produced by the leading wnt zone. This is why the variable" cxcl12a-speed" determines the speed of wnter cells, and "fgf-speed" fgfer cells. The "migration-delay" slider causes migration to not start until the set amount of ticks have passed. This can be helpful to let cells settle and form inital connections before they start to move.

### GROWTH SETTINGS
The "proliferation-rate" slider changes the chance that a cell creates another cell. The switches "wnter-proliferate?" and "fgfer-proliferate?" turn on the ability of those respective cells to create new ones. When a cell creates a new cell, the new cell has the same breed as the cell that created it. The "Total Pllp Cells" moniter keeps count of the total amount of cells.

### LINK SETTINGS
The "cell-radius" slider changes the distance that cells can make links to one another. The "cell-break-threshold" slider changes how long links can stretch before they break. The "cell-turnover" slider changes how often links break randomly.

### SPRING SETTINGS
The _layout-spring_ function allows Netlogo to arrange cells as if their attached links are springs. The sliders for "spring-constant" changes the ability of the link to resist changes in length. The sliders for "spring-length" sets the natural length of the link. The sliders for "cell-repulsion-constant" changes the amount that cells repel each other.

### OTHER
To recreate the simulations present in the main research paper, click the buttons (INSERT BUTTON NAMES HERE). 

If your migration speed is set very fast or you run the simulation for a long time, the primordium will eventually hit the right wall of the environment. You can change the shape of the environment to make it longer or shorter by clicking the "Settings" button towards the top of the screen and changing "max-pycor".

## NETLOGO FEATURES

### BEHAVIOR SPACE

You can use the Behavior Space tool (_Tools > BehaviorSpace_) to automate parameter testing and create videos of simulations. The premade experiment Movie_Maker contains everything needed to create images of a simulation, which can then be assembled in Fiji or other software to create a video.

To create a movie using Movie_Maker, click on the experiment "Movie_Maker" in BehaviorSpace and then click "Edit". In the  "Vary variables as follows..." box, you can set what values variables will have during simulations. Either list values to use (["variable" 2 5 6.2 7] will have 4 simulations at those different values) or specify start, increment, and end (["variable" [0 1 10]] will vary variable from 0 to 10 in increments of 1, 11 simulations total).

IMPORTANT
If you want to make movies of an experiment with duplicate simulations, do not use the "Repetitions" box. Make sure this value remains at "1". Instead use the variable "repetitions" and have it vary to create your duplicates (["repetitions" [1 1 5]] will give you 5 duplicates). This prevents your simulation movies from overwriting themselves. The "repetitions" variable is already provided for you in "Movie_Maker".

Besides the "Repetitions" box, you may add what you like to the other boxes to shape your simulations to your liking. More information on what you can do with BehaviorSpace can be found [here](https://ccl.northwestern.edu/netlogo/docs/behaviorspace.html).

Images of your simulation can be taken using the "export-view" command. The Movie_Maker experiment takes one image of the inital conditions and then an image every 10 ticks and exports them as .pngs. You can change the name these images are saved as by changing what comes after "word" in the line of code. We reccommend always including the variables "repetitions" and "ticks" in the name to prevent overwriting data and for easy sorting. To change how often images are taken, change the mod equation of the if statement in the "Go commands" box. "ticks mod 10 = 0" will image every 10 ticks, "ticks mod 23 = 0" will image every 23 ticks, etc.

Once you are done editing, you can run the experiment by clicking "run" in BehaviorSpace. You may select if you want spreadsheets/plots/etc. listing variables and data exported and where. Once you click "OK", the experiments will run and the images will be saved in the same place your model is currently saved. These images can then be assembled into a video.

## CREDITS AND REFERENCES

Ajay Chitnis
Section on Neural Developmental Dynamics
Eunice Kennedy Shriver National Institute of Child Health and Human Development
National Institutes of Health
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

hexagon
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
<experiments>
  <experiment name="Movie_Maker" repetitions="1" runMetricsEveryStep="false">
    <setup>setup
export-view (word repetitions "_WntFrac" Wnt-fraction "_s" Wnt-spring-constant "_f" fgf-speed "_w" wnt-speed "_t" ticks ".png")</setup>
    <go>go
if ticks mod 10 = 0 [
export-view (word repetitions "_WntFrac" Wnt-fraction "_s" Wnt-spring-constant "_f" fgf-speed "_w" wnt-speed "_t" ticks ".png")
]</go>
    <timeLimit steps="2000"/>
    <steppedValueSet variable="repetitions" first="1" step="1" last="5"/>
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
