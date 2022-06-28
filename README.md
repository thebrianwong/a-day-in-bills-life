# WIP

6/27:

Additions:

- Added some new comments.

Adjustments:

- Reworded multiple comments.

- Reorganized the placement of blocks of code to have a more logical layout.

- Cleaned up and removed some unnecessary bits of code.

6/26:

Additions:

- Added and updated some comments.

- Made the player turn from red back to normal color after colliding with mario.

  - Changed player.lua draw parameters to support this feature.

- Made the player fade away after colliding with mario.

  - Created variable playerOpacity to support this feature.
  
- Added game stats support for goombas that is similar to coins.

  - Created multiple variables to support this feature.
  
Adjustments:

- Moved speed properties from objects, except player, to entity.lua.

- Adjusted the results screen timing.

- Renamed variable alpha to resultsScreenOpacity.

- Changed the horizontal spawning zone of coins and goombas to be wider, and to not use explicit window dimensions.

- Changed HUD to stop appearing once player loses control.

6/25:

Additions:

- Introduced feature where player will wait a few seconds after colliding mario to start falling down.

  - Created variable timerCrashed to support this feature.

Adjustments:

- Renamed variable t to timerResultsScreen to keep track of when user can restart the game.

- Changed the logic for objectSpeed to stop decreasing after colliding with mario.

- Altered logic so that coins and goombas stop spawning and scrolling after player collides with mario.

6/24:

Additions:

- Got the "press any key to start game" and "press spacebar to play again" features implemented with proper logic (no play again when results screen is still loading     on the 2nd playthrough).

- Added the beginnings of a new part of the game where the player slides off-screen after crashing into mario.
  - Introduced variable crash to keep track of this.
  
 Adjustments:
 
- Adjusted HUD to now only display speed and collected coins so that the other stats will only be displayed in the results screen.

  - Changed the wording from "Collected" to "Coins" to be more clear.
  
  - Made the black panel smaller due to these changes.
  
- Moved the code that prevents the player from moving off-screen from player.lua to main.lua, so that it can be disabled after colliding with mario.

6/23:

Additions:

- Introduced isGameState variable to further keep track of game states.

- Refined the fade to black to results screen feature.
  - Renamed function fadeIn() to fadeToBlack().
  - Results screen currently contains placeholder text with game stats.
  
Adjustments:
 
 - Removed the require "fade" because it was leftover from experimenting with the fade feature.
 
 - Changed the number of coins and goombas on screen to make testing faster.
 
 - Put the actual game code in an if-statement for the new isGameState variable.

6/22:

Additions:

- Got started with creating a fade in to the results screen upon colliding with mario.

Adjustments:

- Removed old fade in prototype.

- Removed duplicate block of code used to set background to blue to address vertical black bars issue.

6/21:

Additions:

- Added some new comments.

- Added new text to the title screen.

- Started working on a results screen after the game ends.

Adjustments:

- Changed the placements of the text on the title screen to be better centered.

6/20:

Additions:

- Added a title screen that that will contain the title and some story/instructions.

- Created next text.lua file that will house all of the text that is displayed in the title screen and will also probably be later used in a result screen.

Adjustments:

- Moved the order of the background drawing block of code to before the title screen block of code so that the screen is scrolling even while in the title screen.

6/19:

Additions:

- Refined the forced movement of the player to be smoother with better logic and new functions forceX() and forceY().

- Added comments to blocks of code without any comments.

Adjustments:

- Removed some miscellaneous unncecessary lines of code that were turned into comments.

- Changed the placement of some blocks of code so that they aren't randomly scattered.

- Reworded the wording of some comments.

- Changed coinSpeed to objectSpeed to more accurately reflect its purpose and application.

- Changed the name of function change

- Removed the passive speed up of the player because it was kinda pointless.

- Removed the reversal of the player color change to red because the player sometimes doesn't
  fully turn red by the time the player collides with mario.
 
- Changed the order in which every entity is drawn so that the player, coin, and goomba is draw
  underneath the game stat HUD.
  
- Changed the name of function speedUp() to changeSpeed() to reflect that it can both increase and
  decrease speed, as well as removed the dt parameter.

6/18:

Additions:

- Created mario object that will scroll on screen once player hits 1500 speed. When player and mario collide, they stop moving, coin and goomba stop respawning, and     background stops scrolling. Player is forced into a certain position on the screen once 1500 speed is hit. This functionality could be improved.

- Added a function where once player hits 1000 speed, they can't go past a certain part of the screen.

- Made it so that player reverts from being as red when colliding with a goomba, albeit at a slower rate than turning red.
  
Adjustments:

- Changed goomba starting rotation value to 0 instead of 2pi.

- Adjusted the rate at which player changes to red color upon colliding with a coin.

6/17:

Additions:

- Created ability for player to gradually become red as it became faster. The change would happen with the new function call drawColor() in the player.lua file. A       global variable playerColor is initalized to keep track how red the player should be. This variable is passed to the new function to draw the player in a shade of     red. The variable changes when the player collides with a coin.
  
Adjustments:

- Adjusted some speed numbers to that the speed gained with a coin is greater than the speed lost with a goomba.

- Removed the speed cap for player, coin, and goomba. I think the crazy speed is more fun.

6/16:

Additions:

- Made bandage solution for scrolling black bars by setting the background color to be the same blue as the scrolling background. Good solution in that it is only one   line of code, but bad solution because there is still some choppyness that adds up over time to the background images laying over each other. It is not really         noticeable because of how fast things are, but it it still something to consider.
  - Still does not use dt in scrolling calculation because that screws up the overlapping even more.
  
Adjustments:

- Deleted some unnecessary and other miscellaneous lines of code.

- Changed the names of the background variable so that they are more clear.

6/15:

Additions:

- Added config file to force vsync on to address the next point

- Got scrolling background closer to work, but has issue of weird black vertical line stutter. Looked online and turned vsync on but still has error.

Adjustments:

- Changed the logic of the scrolling background so that their x coordinates get reset to to off screen, instead of removing and adding a new object for the illusion of   an infinite scrolling background.

6/14: followed new workflow

Additions:

- Created a translucent black square HUD for game stats for better visilbiity.

Adjustments:

- Changed background from a static image to a moving image. Makings of a prototype work. Will finalize it so that the background gets draw properly with correct         coordinates. One fear is that they will move too fast and there will be weird black choppy lines.
  
- Corrected the function names of coin and goomba object files.

6/13: changed push workflow to manually creating a new branch, uploading files, and updating readme

Additions:

- Added rotation of goombas.
  - Only 1 thing but took a long time to figure out.

6/12: still can't figure out how to push changes via git bash, so just manually uploaded files

Additions:

- Created global variable for coin speed, also used by other entities.
- Added variables and in game display to keep track of miscellaneous game stats.
- Created goomba file and entity. A lot of similar behaviour with coin. Speed is capped.
- Created function speedUp() to increase speed of entities when called.
- Created function displayInfo() to display game stats when called.

Adjustments:
- Changed some of the speed gaining values for player and coin for better game feel.
- Capped the speed of player and coin.

6/11: tried to set up repo and push changes via Git. Had already done a bunch of stuff locally.

Existing functionalities that I can remember:
  
- Classes exist with collision check.
- Player exists with image, can move with arrow keys, speed increases when collision with coin, speed slowly increases by default.
  -  Camera fixed on player, but unsure if that will stay.
- Coin exists with image, moves to left of screen, disappears when touching left side of screen, disappears when touched by player.
  - Coin gets created as a table initially and when respawning with function call createCoin(), spawns off screen on right randomly.
- Background image exists.
- Speed counter exists and is based on player speed.
