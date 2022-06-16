# WIP

6/15:

Additions:

- Added config file to force vsync on to address the next point

- Got scrolling background closer to work, but has issue of weird black vertical line stutter.
  Look online and turned vsync on but still has error.

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
