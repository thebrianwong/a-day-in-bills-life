function love.load()
  Object = require "classic"
  require "entity"
  require "player"
  require "coin"
  require "goomba"
  require "mario"
  require "background"
  require "text"
  
  -- Keeps track of if player has collided with mario.
  crashed = false
  
  -- Starts game in the title screen.
  isTitleScreen = true
  
  -- Keeps track of if game is running in game state.
  isGameScreen = false
  
  -- Move to results screen after game ends.
  isResultsScreen = false
  
  -- Variables used for results screen logic.
  resultsScreenOpacity = 0
  timerResultsScreen = 0
  
  -- Load images because their dimensions will be used for later
  -- calculations for background and mario.
  background_image = love.graphics.newImage("background.png")
  mario_image = love.graphics.newImage("mario.png")
  
  -- Keeps track of the scrolling speed of the background.
  backgroundSpeed = 0.5
  
  -- Used to alter player appearance.
  playerColor = 255
  playerOpacity = 1
  
  -- Determines if the player has restricted horizontal movement.
  speedBarrier = false  
  
  -- Timer to keep track of time since player collided with mario.
  timerCrashed = 0
  
  -- Timer to keep track of when mario moves left off-screen.
  timerMario = 0
  
  -- Determines speed of coins, goombas, and mario.
  objectSpeed = 50
  
  -- Keep track of game stats.
  collectedCoins = 0
  missedCoins = 0
  streakCoinsCurrent = 0
  streakCoinsBest = 0
  hitGoombas = 0
  avoidedGoombas = 0
  streakGoombasCurrent = 0
  streakGoombasBest = 0
  
  -- Spawns multiple instances of the background on and off-screen to scroll.
  backgroundTable = {}
  for i = 0, 2 do
    for j = 0, 2 do
      background = Background(j * background_image:getWidth(), i * background_image:getHeight())
      background.speed = backgroundSpeed
      table.insert(backgroundTable, background)
    end
  end

  -- Spawns player.
  player = Player(150, 250)
  
  -- Loads mario off-screen, not visible to the user at the
  -- beginning of the game. Mario is vertically centered.
  mario = Mario(900, (love.graphics.getHeight() / 2) - (mario_image:getHeight() / 2))
  
-- Spawns initial 5 coins.
  coinTable = {}
  for i=1,5 do
    coin = createCoin()
    table.insert(coinTable, coin)
  end
  
  -- Spawns initial 10 goombas.
  goombaTable = {}
  for i=1,10 do
    goomba = createGoomba()
    table.insert(goombaTable, goomba)
  end
end

function love.update(dt)
  -- When the background goes off-screen, it reappears off-screen
  -- on the right to scroll again indefinitely.
  for i,background in ipairs(backgroundTable) do
    background:update(dt)
    if background.x + background.width <= 0 then
      background.x = 2 * background.width - backgroundSpeed
    end
  end
  
  -- Ignore the game code while on the title screen.
  if isTitleScreen then
    return
  end


  -- Ignore the game code while on the result screen.
  if isResultsScreen then
    if resultsScreenOpacity < 0.99 and isResultsScreen then
      resultsScreenOpacity = resultsScreenOpacity + 0.5 * dt
    end
    if resultsScreenOpacity > 0.95 then
      timerResultsScreen = timerResultsScreen + 1 * dt
    end
    return
  end
  
  player:update(dt)
  mario:update(dt)
  
  -- Once 1500 speed is reached, the user can no longer control
  -- the movement of player, and the player is forced to the 
  -- approximate coordinates of (300, 186). Mario starts scrolling
  -- once that happens. The coordinates line up with mario's nose.
  if objectSpeed > 1500 and crashed == false then
    player.speed = 0
    if player.x > 302 then
      forceX(player, -100, dt)
    elseif player.x < 298 then
      forceX(player, 100, dt)
    end
    if player.y > 188 then
      forceY(player, -100, dt)
    elseif player.y < 184 then
      forceY(player, 100, dt)
    end
    if (player.x >= 298 and player.x <= 302) and (player.y >= 184 and player.y <= 188) then
      timerMario = timerMario + 1 * dt
      if timerMario > 2 then
        mario.speed = objectSpeed
        if mario.x > 370 and mario.x < 385 then
          mario.x = player.x + player.width - 0.1
        end
      end
    end
  end
  
  -- Stops mario from moving and the background from scrolling
  -- once the player collides with mario.
  if player:checkCollision(mario) then
    mario.speed = 0
    for i,background in ipairs(backgroundTable) do
      background.speed = 0
    end
    crashed = true
  end
  
  -- Prevents player from moving off-screen
  if crashed == false then
    if player.y < 0 then
      player.y = 0
    elseif player.y + player.height > love.graphics.getHeight() then
      player.y = love.graphics.getHeight() - player.height
    end
  end
  
  if crashed then
    timerCrashed = timerCrashed + 1 * dt
    playerColor = playerColor + 300 * dt
    if timerCrashed > 2.25 then
      if player.y > 0 and player.y < love.graphics.getWidth() then
        forceY(player, 250, dt)
        playerOpacity = playerOpacity - 0.65 * dt
      elseif player.y >= love.graphics.getWidth() then
        forceX(mario, -350, dt)
        if mario.x + mario.width < 0 then
          isGameScreen = false
          isResultsScreen = true
        end
      end
    end
  end
  
  -- Speed passively increases to contribute to sense of speed.
  if crashed == false then
    objectSpeed = objectSpeed + 0.5 * dt
  end
  
  -- Limits the player's movement to the left side of the screen
  -- once 1000 speed is hit. Stuttering pushback is intentional.
  if (objectSpeed > 1000 or speedBarrier) and crashed == false then
    speedBarrier = true
    if player.x >= 300 then
      forceX(player, -2500, dt)
    end
  end
  
  for i,coin in ipairs(coinTable) do
    coin:update(dt)
    -- The boolean for collision with mario is for the edge case
    -- of preventing coin collision when the game ends with the 
    -- player being forced into specific coordinates to collide 
    -- with mario's nose.
    if player:checkCollision(coin) and objectSpeed < 1500 then
      table.remove(coinTable, i)
      changeSpeed(player, 10)
      objectSpeed = objectSpeed + 10
      backgroundSpeed = backgroundSpeed + 0.025
      if objectSpeed > 750 and playerColor >= 3 then
        playerColor = playerColor - 3
      end
      for i,background in ipairs(backgroundTable) do
        background.speed = backgroundSpeed
      end
      -- Updates game stats
      collectedCoins = collectedCoins + 1
      streakCoinsCurrent = streakCoinsCurrent + 1
      if streakCoinsCurrent > streakCoinsBest then
        streakCoinsBest = streakCoinsCurrent
      end
    end
    coin.speed = objectSpeed
    -- Coin despawns upon hitting the left side of the screen.
    if coin.x < 0 then
      table.remove(coinTable, i)
      missedCoins = missedCoins + 1
      streakCoinsCurrent = 0
    end
  end
  
  for i,goomba in ipairs(goombaTable) do
    goomba:update(dt)
    -- Same reasoning for boolean as for coin.
    if player:checkCollision(goomba) and objectSpeed < 1500 then
      table.remove(goombaTable, i)
      if objectSpeed > 10 and speedBarrier == false then
        changeSpeed(player, -5)
        objectSpeed = objectSpeed - 5
        backgroundSpeed = backgroundSpeed - 0.0125
      end
      -- Updates game stats (save for potential goomba stats)
      hitGoombas = hitGoombas + 1
      streakGoombasCurrent = 0
  --    streakCoinsCurrent = streakCoinsCurrent + 1
  --    if streakCoinsCurrent > streakCoinsBest then
   --     streakCoinsBest = streakCoinsCurrent
   --   end
    end
    goomba.speed = objectSpeed
    -- Goomba despawns upon hitting the left side of the screen.
    if goomba.x < 0 then
      table.remove(goombaTable, i)
      avoidedGoombas = avoidedGoombas + 1
      streakGoombasCurrent = streakGoombasCurrent + 1
      if streakGoombasCurrent > streakGoombasBest then
        streakGoombasBest = streakGoombasBest + 1
      end
    end
  end
  
-- EDIT THIS BACK TO 5 LATER!!!!!!!!!!!!!!!!!!!
  
  -- While loop to ensure that there are always 5 coins present.
  while #coinTable < 25 and objectSpeed < 1500 do
    coin = createCoin()
    coin.speed = objectSpeed
    table.insert(coinTable, coin)
  end

-- EDIT THIS BACK TO 10 LATER!!!!!!!!!!!!!!!!!!!

  -- While loop to ensure that there are always 10 goombas present.
  while #goombaTable < 2 and objectSpeed < 1500 do
    goomba = createGoomba()
    goomba.speed = objectSpeed
    table.insert(goombaTable, goomba)
  end
end

function love.draw()
  -- Sets the canvas background to blue as a solution for scrolling vertical bars.
  -- This is the same blue as the scrolling background.
  love.graphics.setBackgroundColor(40/255, 123/255, 241/255)
  
  -- Draws background images.
  for i,background in ipairs(backgroundTable) do
    background:draw()
  end
  
  -- Title screen.
  if isTitleScreen then
    love.graphics.setColor(0, 0, 0, 0.50)
    love.graphics.rectangle("fill", 20, 20, 760, 560)
    love.graphics.setColor(1, 1, 1)
    love.graphics.printf(textTitle, 322, 100, 150, "left", 0, 1.5, 1.5)
    love.graphics.printf(textStory1, 40, 140, 690, "justify", 0, 1.05, 1.05)
    love.graphics.printf(textStory2, 40, 300, 690, "left", 0, 1.05, 1.05)
    love.graphics.printf(textControls, 235, 425, 290, "center", 0, 1.15, 1.15)
    
    -- Leave the title screen and start the game after pressing any key.
    function love.keypressed(key)
      if isTitleScreen then
        isTitleScreen = false
        isGameScreen = true
      end
    end
    
    return
  end
  
  if isGameScreen then
    -- Draws all entities.
    player:drawColor(playerColor, playerOpacity)
    mario:draw()
    for i,coin in ipairs(coinTable) do
      coin:draw()
    end
    for i,goomba in ipairs(goombaTable) do
      goomba:rotateDraw()
    end
    
    -- Draws translucent black box background for game stats.
    if objectSpeed < 1500 then
      createHUD()
      displayInfo("Speed", string.format("%.2f",objectSpeed), 10, 50)
      displayInfo("Coins", collectedCoins, 10, 70)
    end

    -- Speed counter to maintain a sense of speed. Speed value is for all entities,
    -- not just for player. Speed value is formatted to only display 2 decimal places
    -- because there are, at times, some floating point inprecision, and that would 
    -- look weird to display.
    --displayInfo("Speed", string.format("%.2f",objectSpeed), 10, 50)
    
    -- Other fun miscellaneous game info.
    --displayInfo("Coins", collectedCoins, 10, 70)
    --displayInfo("Missed", missedCoins, 10, 90)
    --displayInfo("Best Streak", streakCoinsBest, 10, 130)
  
    return
  end
  
  -- Results screen.
  if isResultsScreen then
    if resultsScreenOpacity < 1 then
      fadeToBlack(resultsScreenOpacity)
    end
    if timerResultsScreen > 1 then
      love.graphics.printf("Results Screen", 322, 100, 150, "left", 0, 1.5, 1.5)
    end
    if timerResultsScreen > 2 then
      love.graphics.printf("You collected " .. collectedCoins .. " coins", 40, 140, 690, "left", 0, 1.05, 1.05)
    end
    if timerResultsScreen > 3 then
      love.graphics.printf("You missed " .. missedCoins .. " coins", 40, 300, 690, "left", 0, 1.05, 1.05)
    end
    if timerResultsScreen > 4 then
      if streakCoinsBest == 1 then
        love.graphics.printf("The most coins you collected in a row was 1 coin", 40, 425, 690, "left", 0, 1.105, 1.05)
      else
        love.graphics.printf("The most coins you collected in a row were " .. streakCoinsBest .. " coins", 40, 425, 690, "left", 0, 1.105,        1.05)
      end
    end
    
    -- Leave the results screen and restart the game if spacebar is pressed after some time.
    function love.keypressed(key)
      if key == "space" and timerResultsScreen > 4 then
        resetGameState()
        isResultsScreen = false
        isGameScreen = true
      end
    end

    return
  end
  
end

 -- Creates coins off-screen randomly within the dimensions of the window.
function createCoin()
  local x = love.math.random(love.graphics.getWidth(), love.graphics.getWidth() + 200)
  local y = love.math.random(0, love.graphics.getHeight() - 38)
  local coin = Coin(x, y)
  return coin
end

 -- Creates goomba off-screen randomly within the dimensions of the window.
function createGoomba()
  local x = love.math.random(love.graphics.getWidth(), love.graphics.getWidth() + 200)
  local y = love.math.random(0, love.graphics.getHeight() - 43)
  local goomba = Goomba(x, y)
  return goomba
end

-- The player has its own speed independent of the speed of 
-- coins and goombas for better balance. This function alters
-- the player's speed, but can be used for any entity if necessary.
function changeSpeed(entity, speed)
  entity.speed = entity.speed + speed
end

-- Changes an entity's coordinates. Used for forcing the player
-- into some set of specific coordinates, but could also be used
-- for any other entity if necessary.
function forceX(entity, number, dt)
  entity.x = entity.x + number * dt
end
function forceY(entity, number, dt)
  entity.y = entity.y + number * dt
end

-- Displays game info stats.
function displayInfo(info, number, x, y)
  love.graphics.print(info .. ": " .. number, x, y)
end

-- Creates translucent background for game stats.
function createHUD()
  love.graphics.setColor(0, 0, 0, 0.25)
  --love.graphics.rectangle("fill", 5, 45, 121, 105)
  love.graphics.rectangle("fill", 5, 45, 107, 45)
  love.graphics.setColor(1, 1, 1)
end

-- Fade to black into results screen.
function fadeToBlack(alpha)
  love.graphics.setColor(0, 0, 0, alpha)
  love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())
  love.graphics.setColor(1, 1, 1)
end

-- Resets the values of all entities.
function resetGameState()
  resultsScreenOpacity = 0
  backgroundSpeed = 0.5
  crashed = false
  objectSpeed = 50
  playerColor = 255
  playerOpacity = 1
  speedBarrier = false
  timerResultsScreen = 0
  timerMario = 0
  timerCrashed = 0
  collectedCoins = 0
  missedCoins = 0
  streakCoinsCurrent = 0
  streakCoinsBest = 0
  hitGoombas = 0
  avoidedGoombas = 0
  streakGoombasCurrent = 0
  streakGoombasBest = 0
  player.x = 150
  player.y = 250
  player.speed = 100
  mario.x = 900
  mario.y = (love.graphics.getHeight() / 2) - (mario_image:getHeight() / 2)
  mario.speed = 0
  for i,coin in ipairs(coinTable) do
    coin.x = love.math.random(love.graphics.getWidth(), love.graphics.getWidth() + 200)
  end
  for i,goomba in ipairs(goombaTable) do
    goomba.x = love.math.random(love.graphics.getWidth(), love.graphics.getWidth() + 200)
    goomba.rotation = 0
  end
  for i,background in ipairs(backgroundTable) do
    background.speed = backgroundSpeed
  end
end