Goomba = Entity:extend()

function Goomba:new(x, y)
  Goomba.super.new(self, x, y, "goomba.png")
  self.speed = 50
  self.rotation = 2 * math.pi
  --self.image = love.graphics.draw(self.image, self.x, self.y, rotation, 1, 1, self.width / 2, self.height / 2)
end
  
function Goomba:update(dt)
  self.x = self.x - self.speed * dt
  self.rotation = self.rotation - .002 - ((self.speed / 50) * dt)
end

function Goomba:rotateDraw()
  love.graphics.draw(self.image, self.x, self.y, self.rotation, 1, 1, self.width / 2, self.height / 2)
end