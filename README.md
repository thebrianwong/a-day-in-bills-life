# A Day in Bill's Life

#### Video Demo: 
WIP <URL HERE>

#### Description:
A Day in Bill's Life is a side scrolling video game written in Lua with the LÖVE framework in which you play as "Bullet Bill". It's just another regular day in Bill's life where you are entasked by "Bowser" to defeat "Mario". To do so, you must collect coins to go faster and avoid crashing into any "Goombas" that will reduce your speed. Things start off manageable, but soon become hectic as you start speeding through the skies.

#### Files:
##### main.lua:
This file contains all of the logic that dictates the flow of the game. It consists of the required 3 functions of the LÖVE framework to run a game: love.load(), love.update(), and love.draw(). Within these 3 functions is code that you would expect to see after playing the game, such as spawning and despawning of coins and "Goombas", the ability to see your player speed and number of collected coins increase, and the ending sequence of crashing into "Mario". There are also some other  more "under the hood" features, such as the logic of when sound effects play, the logic that determines when the ending sequence plays, and the logic that keeps track of how many coins and "Goombas" you have collected and crashed into.

In addition, there are some supplementary functions at the bottom, including the resetGameState() function that allows the user to replay the game by resetting all of the file's variables to the starting values located in love.load().

##### classic.lua:
This is a library file that allows classes to be created. It can be found [here](https://github.com/rxi/classic) and is used in [Sheepolution's guide to LÖVE on classes](https://sheepolution.com/learn/book/11).

##### entity.lua:
This file draws on class.lua to allow entities to be created in the game. The original file can be found on [another chapter in Sheepolution's guide to LÖVE](https://sheepolution.com/learn/book/23). I have modified it to include the speed property.

##### coin.lua, background.lua, and mario.lua:
These files are pretty barebones. They exist just to create their respective entities that inherit the properties that exist in entity.lua, as well as stating the paths to their respective images.

background.lua is notable because although there is no direct interaction between the player and the background, the file is required to make the background infinitely scroll.

##### goomba.lua:
This file stands out a bit more as it contains a rotation property, which is used so that the "Goombas" can rotate and rotate faster as the game progresses.

##### player.lua:
Because the player is controllable, this file also contains more code. The player actually has a speed that is independent from all other entities and thus the speed that is displayed in game (sorry to break the illusion). The player's color and opacity changes throughout the game, hence why the draw function is different from the one in entity.lua. There is code that allows the player to move based on user input, as well as code that prevents the player from moving horizontally off-screen.

##### text.lua:
This file contains most of the static text shown in the game. This was mainly to accommodate the large paragraph on the title screen, but I just added in some of the other text because the file already existed.

##### conf.lua:
Changes the window title to the name of the game and the window icon to the player icon. Also turns on v-sync.

#### Design Choices:

##### filler:
