Player = Entity:extend()

function Player:new(x, y)
  Player.super.new(self, x, y, "assets/bullet.png")
  self.speed = 100
end

function Player:drawColor(color, opacity)
  love.graphics.setColor(1, color/255, color/255, opacity/1)
  love.graphics.draw(self.image, self.x, self.y)
  love.graphics.setColor(1, 1, 1, 1)
end

function Player:update(dt)
  -- 2 seperate if statements so the player can move diagonally.
  if love.keyboard.isDown("right") then
    self.x = self.x + self.speed * dt
  elseif love.keyboard.isDown("left") then
    self.x = self.x - self.speed * dt
  end
  if love.keyboard.isDown("up") then
    self.y = self.y - self.speed * dt
  elseif love.keyboard.isDown("down") then
    self.y = self.y + self.speed * dt
  end
  
  -- Prevents the player from moving horizontally off-screen.
  if self.x < 0 then
    self.x = 0
  elseif self.x + self.width > love.graphics.getWidth() then
    self.x = love.graphics.getWidth() - self.width
  end
end