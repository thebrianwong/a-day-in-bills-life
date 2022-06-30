function love.load()
  Object = require "classic"
  require "entity"
  require "player"
  require "coin"
  require "goomba"
  require "mario"
  require "background"
  require "text"
  
  -- Keeps track of the current game state.
  isTitleScreen = true
  isGameScreen = false
  isResultsScreen = false
  
  -- Results screen variables.
  
  -- Results screen appearance.
  resultsScreenOpacity = 0
  timerResultsScreen = 0
  
  -- Results screen stats.
  collectedCoins = 0
  missedCoins = 0
  streakCoinsCurrent = 0
  streakCoinsBest = 0
  hitGoombas = 0
  avoidedGoombas = 0
  streakGoombasCurrent = 0
  streakGoombasBest = 0
  
  -- Gameplay variables.
  
  -- Image dimensions to be referenced for coordinate location calculations.
  background_image = love.graphics.newImage("background.png")
  mario_image = love.graphics.newImage("mario.png")
  
  -- Used to calculate how fast different aspects of the game scroll and move.
  backgroundSpeed = 20
  objectSpeed = 50
  
  -- Dictates flow and logic of gameplay.
  speedBarrier = false  
  crashed = false
  timerCrashed = 0
  timerMario = 0

  -- Player related variables.
  player = Player(150, 250)
  playerColor = 255
  playerOpacity = 1
  
  -- Spawns mario off-screen and vertically centered with the screen.
  mario = Mario(900, (love.graphics.getHeight() / 2) - (mario_image:getHeight() / 2))
  
  -- Spawns the background, coins, and goombas.
  backgroundTable = {}
  for i = 0, 1 do
    for j = 0, 2 do
      background = Background(j * background_image:getWidth(), i * background_image:getHeight())
      background.speed = backgroundSpeed
      table.insert(backgroundTable, background)
    end
  end  
  coinTable = {}
  for i=1,5 do
    coin = createCoin()
    table.insert(coinTable, coin)
  end
  goombaTable = {}
  for i=1,10 do
    goomba = createGoomba()
    table.insert(goombaTable, goomba)
  end
end

function love.update(dt)
  -- Creates an infinitely scrolling background. Allows for scrolling even on the title screen.
  for i,background in ipairs(backgroundTable) do
    if background.x + background.width < 0 then
      if i == 1 then
        background.x = backgroundTable[3].x + background.width
      elseif i == 2 then
        background.x = backgroundTable[1].x + background.width
      elseif i == 3 then
        background.x = backgroundTable[2].x + background.width
      end
      if i == 4 then
        background.x = backgroundTable[6].x + background.width
      elseif i == 5 then
        background.x = backgroundTable[4].x + background.width
      elseif i == 6 then
        background.x = backgroundTable[5].x + background.width
      end
    end
    background:update(dt)
  end
  
  -- Ignores the below code while on the title screen.
  if isTitleScreen then
    return
  end

  -- Ignore the below code while on the result screen.
  if isResultsScreen then
    if resultsScreenOpacity < 0.99 then
      resultsScreenOpacity = resultsScreenOpacity + 0.5 * dt
    else
      timerResultsScreen = timerResultsScreen + 1 * dt
    end
    return
  end
  
  -- Updates entities.
  player:update(dt)
  mario:update(dt)
  for i,coin in ipairs(coinTable) do
    coin:update(dt)
    -- When the player collects a coin, all entities' speed increase, and the player becomes more red pass a speed of 750.
    if player:checkCollision(coin) and objectSpeed < 1500 then
      table.remove(coinTable, i)
      changeSpeed(player, 10)
      objectSpeed = objectSpeed + 10
      backgroundSpeed = backgroundSpeed + 8
      if objectSpeed > 750 and playerColor >= 3 then
        playerColor = playerColor - 3
      end
      for i,background in ipairs(backgroundTable) do
        background.speed = backgroundSpeed
      end
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
    -- When the player hits a goomba, all entities' speed decrease down to a certain point.
    if player:checkCollision(goomba) and objectSpeed < 1500 then
      table.remove(goombaTable, i)
      -- The player can't hit a goomba in the final stage of the game.
      if objectSpeed > 10 and speedBarrier == false then
        changeSpeed(player, -5)
        objectSpeed = objectSpeed - 5
        backgroundSpeed = backgroundSpeed - 4
      end
      hitGoombas = hitGoombas + 1
      streakGoombasCurrent = 0
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
  
-- EDIT COINS BACK TO 5 LATER!!!!!!!!!!!!!!!!!!! EDIT GOOMBAS BACK TO 10 LATER!!!!!!!!!!!!!!!!!!!
  
  -- Respawns coins and goombas. Stops at the end of the game.
  while #coinTable < 25 and objectSpeed < 1500 do
    coin = createCoin()
    coin.speed = objectSpeed
    table.insert(coinTable, coin)
  end
  while #goombaTable < 2 and objectSpeed < 1500 do
    goomba = createGoomba()
    goomba.speed = objectSpeed
    table.insert(goombaTable, goomba)
  end
  
  --[[
  Restricts the player's range of horizontal movement by creating an illusion of an invisible speed barrier/wall.
  speedBarrier prevents the barrier from "disappearing" if objectSpeed were to drop back below 1000 after reaching above 1000.
  ]]--
  if objectSpeed > 1000 or speedBarrier then
    speedBarrier = true
    if player.x >= 300 then
      forceX(player, -2500, dt)
    end
  end   
  
  -- At the end of the game, the player can't be controlled and is forced to specific coordinates so that it crashes into mario's nose.
  if objectSpeed > 1500 then
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
        -- This prevents the sprites of the player and mario from overlapping.
        if mario.x > 370 and mario.x < 385 then
          mario.x = player.x + player.width - 0.1
        end
      end
    end
  end
  
  -- Stops mario from moving and the background from scrolling after the player collides with mario.
  if player:checkCollision(mario) then
    mario.speed = 0
    for i,background in ipairs(backgroundTable) do
      background.speed = 0
    end
    crashed = true
  end
  
  --[[
  Sequence of events that take place after player collides with mario. The player reverts back from red then falls and fades away.
  Mario then moves off-screen.
  ]]--
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
  
  -- Prevents player from moving off-screen during regular gameplay.
  if crashed == false then
    if player.y < 0 then
      player.y = 0
    elseif player.y + player.height > love.graphics.getHeight() then
      player.y = love.graphics.getHeight() - player.height
    end
  end
end

function love.draw()
  -- Sets the canvas background to blue as a solution for scrolling vertical bars. This is the same blue as the scrolling background.
  --love.graphics.setBackgroundColor(40/255, 123/255, 241/255)
  
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
  
  -- Lists out various game instance stats in a result screen.
  if isResultsScreen then
    if resultsScreenOpacity < 1 then
      fadeToBlack(resultsScreenOpacity)
    end
    if timerResultsScreen > 1 then
      love.graphics.printf("Results Screen", 322, 100, 150, "left", 0, 1.5, 1.5)
    end
    if timerResultsScreen > 2 then
      love.graphics.draw(coin.image, 700, 160)
      if collectedCoins == 1 then
        love.graphics.printf("You collected 1 coin", 40, 160, 690, "left", 0, 1.05, 1.05)
      else
        love.graphics.printf("You collected " .. collectedCoins .. " coins", 40, 160, 690, "left", 0, 1.05, 1.05)
      end
    end
    if timerResultsScreen > 3 then
      if missedCoins == 1 then
        love.graphics.printf("You missed 1 coin", 40, 180, 690, "left", 0, 1.05, 1.05)
      else
        love.graphics.printf("You missed " .. missedCoins .. " coins", 40, 180, 690, "left", 0, 1.05, 1.05)
      end
    end
    if timerResultsScreen > 4 then
      if streakCoinsBest == 1 then
        love.graphics.printf("The most coins you collected in a row was 1 coin", 40, 200, 690, "left", 0, 1.105, 1.05)
      else
        love.graphics.printf("The most coins you collected in a row were " .. streakCoinsBest .. " coins", 40, 200, 690, "left", 0, 1.105,        1.05)
      end
    end
    if timerResultsScreen > 5 then 
      love.graphics.draw(goomba.image, 700, 260)
      love.graphics.printf("You hit " .. hitGoombas .. " goombas", 40, 260, 690, "left", 0, 1.05, 1.05)
    end
    -- Leave the results screen and restart the game if spacebar is pressed.
    function love.keypressed(key)
      if key == "space" and timerResultsScreen > 6 then
        resetGameState()
        isResultsScreen = false
        isGameScreen = true
      end
    end
    return
  end
  
  -- Draws entities to the canvas.
  player:drawColor(playerColor, playerOpacity)
  mario:draw()
  for i,coin in ipairs(coinTable) do
    coin:draw()
  end
  for i,goomba in ipairs(goombaTable) do
    goomba:rotateDraw()
  end
    
  -- Show player speed and collected coins in top left HUD.
  if objectSpeed < 1500 then
    createHUD()
    displayInfo("Speed", string.format("%.2f",objectSpeed), 10, 50)
    displayInfo("Coins", collectedCoins, 10, 70)
  end
end

 -- Creates coins off-screen randomly.
function createCoin()
  local x = love.math.random(love.graphics.getWidth(), love.graphics.getWidth() + 200)
  local y = love.math.random(0, love.graphics.getHeight() - 38)
  local coin = Coin(x, y)
  return coin
end

 -- Creates goomba off-screen randomly.
function createGoomba()
  local x = love.math.random(love.graphics.getWidth(), love.graphics.getWidth() + 200)
  local y = love.math.random(0, love.graphics.getHeight() - 43)
  local goomba = Goomba(x, y)
  return goomba
end

-- Changes an entity's speed.
function changeSpeed(entity, speed)
  entity.speed = entity.speed + speed
end

-- Changes an entity's coordinates without regard for the entity's speed.
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
  backgroundSpeed = 20
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