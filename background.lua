Background = Entity:extend()

function Background:new(x, y)
  Background.super.new(self, x, y, "background.png")
  self.speed = 1
end
  
function Background:update(dt)
  self.x = self.x - self.speed
end