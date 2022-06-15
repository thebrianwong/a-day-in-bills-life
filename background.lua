Background = Entity:extend()

function Background:new(x, y)
  Background.super.new(self, x, y, "background.png")
  self.speed = 150
end
  
function Background:update(dt)
  self.x = self.x - self.speed * dt
end