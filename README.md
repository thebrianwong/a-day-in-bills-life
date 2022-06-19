# WIP

6/18:

Additions:

- Created mario object that will scroll on screen once player hits 1500 speed. When player and mario collide,
  they stop moving, coin and goomba stop respawning, and background stops scrolling. Player is forced into a
  certain position on the screen once 1500 speed is hit. This functionality could be improved.

- Added a function where once player hits 1000 speed, they can't go past a certain part of the screen.

- Made it so that player reverts from being as red when colliding with a goomba, albeit at a slower rate than
  turning red.
  
Adjustments:

- Changed goomba starting rotation value to 0 instead of 2pi.

- Adjusted the rate at which player changes to red color upon colliding with a coin.

6/17:

Additions:

- Created ability for player to gradually become red as it became faster. The change would happen with the 
  new function call drawColor() in the player.lua file. A global variable playerColor is initalized to keep
  track how red the player should be. This variable is passed to the new function to draw the player in a shade
  of red. The variable changes when the player collides with a coin.
  
Adjustments:

- Adjusted some speed numbers to that the speed gained with a coin is greater than the speed lost with a goomba.

- Removed the speed cap for player, coin, and goomba. I think the crazy speed is more fun.

6/16:

Additions:

- Made bandage solution for scrolling black bars by setting the background color to be the same blue as the
  scrolling background. Good solution in that it is only one line of code, but bad solution because there
  is still some choppyness that adds up over time to the background images laying over each other. It is not
  really noticeable because of how fast things are, but it it still something to consider.
  - Still does not use dt in scrolling calculation because that screws up the overlapping even more.
  
Adjustments:

- Deleted some unnecessary and other miscellaneous lines of code.

- Changed the names of the background variable so that they are more clear.

6/15:

Additions:

- Added config file to force vsync on to address the next point

- Got scrolling background closer to work, but has issue of weird black vertical line stutter.
  Look online and turned vsync on but still has error.

Adjustments:

- Changed the logic of the scrolling background so that their x coordinates get reset to to off screen,
  instead of removing and adding a new object for the illusion of an infinite scrolling background.

6/14: followed new workflow

Additions:

- Created a translucent black square HUD for game stats for better visilbiity.

Adjustments:

- Changed background from a static image to a moving image. Makings of a prototype work. Will finalize it
  so that the background gets draw properly with correct coordinates. One fear is that they will move too
  fast and there will be weird black choppy lines.
  
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
