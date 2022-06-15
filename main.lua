function love.load()
  Object = require "classic"
  require "entity"
  require "player"
  require "coin"
  require "goomba"
  require "background"
  background = love.graphics.newImage("background.png")
  
  player = Player(150, 250)
  
  
  backgroundTable = {}
  
  temp = Background(0, 0)
  
  for i = 0, 1 do
    for j = 0, 1 do
      bg = Background(j * temp.width, i * temp.height)
      table.insert(backgroundTable, bg)
    end
  end
  
  print(#backgroundTable)
  
  coinTable = {}

  -- Initially spawns 5 coins
  for i=1,5 do
    coin = createCoin()
    table.insert(coinTable, coin)
  end
  
  -- Global variable to keep track of the speed of all coins
  -- Updating the speed of each individual coin on screen is an issue due to
  -- the fact that when a coin despawns, the new coin can't keep track of
  -- the previous speed without this global variable
  coinSpeed = 50
  
  -- Initialize other variables to keep track of game instance info
  collectedCoins = 0
  missedCoins = 0
  streakCoinsCurrent = 0
  streakCoinsBest = 0
  
  goombaTable = {}
  
  for i=1,10 do
    goomba = createGoomba()
    table.insert(goombaTable, goomba)
  end
  
end

function love.update(dt)
  player:update(dt)
  
  -- Constantly increasing coin speed by a negligible amount so that
  -- the speed counter is constantly increasing and doesn't only increase
  -- when the player collides with a coin
  coinSpeed = coinSpeed + 0.5 * dt
  
  speedUp(player, 0.75, dt)
  
  for i,bg in ipairs(backgroundTable) do
    bg:update(dt)
    if bg.x + bg.width < 0 then
      table.remove(backgroundTable, i)
    end
    while #backgroundTable < 5 do
      print(#backgroundTable)
      bg = Background(800, 0)
      table.insert(backgroundTable, bg)
      bg1 = Background(800, 400)
      table.insert(backgroundTable, bg1)
    end
  end
  
  for i,coin in ipairs(coinTable) do
    coin:update(dt)
    if player:checkCollision(coin) then
      table.remove(coinTable, i)
      if player.speed < 300 then
        speedUp(player, 5, 1)
      end
      coinSpeed = coinSpeed + 5
      -- Updates game stats
      collectedCoins = collectedCoins + 1
      streakCoinsCurrent = streakCoinsCurrent + 1
      if streakCoinsCurrent > streakCoinsBest then
        streakCoinsBest = streakCoinsCurrent
      end
      print(coin.speed)
      print(player.speed)
    end
    if coin.x < 0 then
      table.remove(coinTable, i)
      missedCoins = missedCoins + 1
      streakCoinsCurrent = 0
    end
  end
  
  for i,goomba in ipairs(goombaTable) do
    goomba:update(dt)
    if player:checkCollision(goomba) then
      table.remove(goombaTable, i)
      if player.speed > 50 then
        speedUp(player, -5, 1)
      end
      coinSpeed = coinSpeed - 5
      -- Updates game stats
      --collectedCoins = collectedCoins + 1
      --streakCoinsCurrent = streakCoinsCurrent + 1
      --if streakCoinsCurrent > streakCoinsBest then
        --streakCoinsBest = streakCoinsCurrent
      --end
    end
    if goomba.x < 0 then
      table.remove(goombaTable, i)
    end
  end
  
  -- While loop to ensure that there are always 5 coins present
  while #coinTable < 5 do
    coin = createCoin()
    -- Caps coin speed at 500 while still letting the displayed speed counter to increase
    if coinSpeed < 500 then
      coin.speed = coinSpeed
    else
      coin.speed = 500
    end
    table.insert(coinTable, coin)
  end

  while #goombaTable < 10 do
    goomba = createGoomba()
    -- Caps coin speed at 500 while still letting the displayed speed counter to increase
    if coinSpeed < 250 then
      goomba.speed = coinSpeed
    else
      goomba.speed = 250
    end
    table.insert(goombaTable, goomba)
  end
  
end

function love.draw()

  -- Draws the background image to the game
 -- for i = 0, love.graphics.getWidth() / background:getWidth() do
 --   for j = 0, love.graphics.getHeight() / background:getHeight() do
 --     love.graphics.draw(background, i * background:getWidth(), j * background:getHeight())
 --   end
 -- end
  
  for i,bg in ipairs(backgroundTable) do
    bg:draw()
  end
  
  -- Draws translucent black box background for game stats
  hud()
  
  -- love.graphics.translate(-player.x + 150, -player.y + 250)
  player:draw()
  
  for i,coin in ipairs(coinTable) do
    coin:draw()
  end
  
  for i,goomba in ipairs(goombaTable) do
    goomba:rotateDraw()
  end
  

  -- Speed counter that is actually based on coin speed, not player speed
  -- This is so that the player's speed can be capped but still
  -- maintain a sense of speed via the coins
  -- Speed value is formatted to only display 2 decimal places because there
  -- are, at times, some floating point inprecision, and that would look weird to display
  displayInfo("Speed", string.format("%.2f",coinSpeed), 10, 50)
  
  -- Other fun miscellaneous game info
  displayInfo("Collected", collectedCoins, 10, 70)
  displayInfo("Missed", missedCoins, 10, 90)
  displayInfo("Current Streak", streakCoinsCurrent, 10, 110)
  displayInfo("Best Streak", streakCoinsBest, 10, 130)
end

function createCoin()
 -- Creates coin off-screen randomly within the dimension of the window
  local x = love.math.random(800, 950)
  local y = love.math.random(0, love.graphics.getHeight() - 38)
  local coin = Coin(x, y)
  return coin
end

function createGoomba()
 -- Creates coin off-screen randomly within the dimension of the window
  local x = love.math.random(800, 1000)
  local y = love.math.random(0, love.graphics.getHeight() - 43)
  local goomba = Goomba(x, y)
  return goomba
end

function speedUp(entity, speed, dt)
  entity.speed = entity.speed + speed * dt
end

function displayInfo(info, number, x, y)
  -- Displays game info stats
  love.graphics.print(info .. ": " .. number, x, y)
end

function hud()
  love.graphics.setColor(0, 0, 0, 0.25)
  love.graphics.rectangle("fill", 5, 45, 115, 105)
  love.graphics.setColor(1, 1, 1)
end