function love.load()
  Object = require "classic"
  require "entity"
  require "player"
  require "coin"
  background = love.graphics.newImage("background.png")
  
  player = Player(150, 250)
  
 coinTable = {}

  for i=1,5 do
    coin = createCoin()
    table.insert(coinTable, coin)
  end
end

function love.update(dt)
  player:update(dt)
  player.speed = player.speed + 1 * dt
  
  for i,coin in ipairs(coinTable) do
    coin:update(dt)
    if player:checkCollision(coin) then
      table.remove(coinTable, i)
      player.speed = player.speed + 25
      coin.speed = coin.speed + 20
      print(coin.speed)
    end
    if coin.x < 0 then
      table.remove(coinTable, i)
    end
    coin:update(dt)
  end
  
  while #coinTable < 5 do
    coin = createCoin()
    coin.speed = coin.speed + 20
    table.insert(coinTable, coin)
   -- coin.speed = coin.speed + 20
  --  print(coin.speed)
  end

end

function love.draw()

  for i = 0, love.graphics.getWidth() / background:getWidth() do
    for j = 0, love.graphics.getHeight() / background:getHeight() do
      love.graphics.draw(background, i * background:getWidth(), j * background:getHeight())
    end
  end
  
  love.graphics.print("Speed: " .. player.speed, 10, 30)
  --love.graphics.translate(-player.x + 150, -player.y + 250)
  player:draw()
 
  for i,coin in ipairs(coinTable) do
    coin:draw()
  end

end

function createCoin()
 -- local x = love.math.random(600, love.graphics.getWidth() - 15)
  local x = love.math.random(800, 850)
  local y = love.math.random(15, love.graphics.getHeight() - 15)
  local coin = Coin(x, y)
  return coin
end