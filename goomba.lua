Goomba = Entity:extend()

function Goomba:new(x, y)
  Goomba.super.new(self, x, y, "assets/images/goomba.png")
  self.rotation = 0
end
  
function Goomba:update(dt)
  self.x = self.x - self.speed * dt
  self.rotation = self.rotation - ((self.speed / 75) * dt)
end

function Goomba:rotateDraw()
  love.graphics.draw(self.image, self.x, self.y, self.rotation, 1, 1, self.width / 2, self.height / 2)
end