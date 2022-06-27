Entity = Object:extend()

function Entity:new(x, y, image_path)
  self.x = x
  self.y = y
  self.image = love.graphics.newImage(image_path)
  self.width = self.image:getWidth()
  self.height = self.image:getHeight()
  self.speed = 0
end

function Entity:update(dt)
  self.x = self.x - self.speed * dt
end

function Entity:draw()
  love.graphics.draw(self.image, self.x, self.y)
end

function Entity:checkCollision(e)
  return self.x + self.width > e.x
  and self.x < e.x + e.width
  and self.y + self.height > e.y
  and self.y < e.y + e.height
end