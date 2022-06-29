Background = Entity:extend()

function Background:new(x, y)
  Background.super.new(self, x, y, "background.png")
end
  
function Background:update(dt)
  self.x = self.x - self.speed * dt
end