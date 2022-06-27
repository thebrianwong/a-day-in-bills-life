Mario = Entity:extend()

function Mario:new(x, y)
  Mario.super.new(self, x, y, "mario.png")
end
  
function Mario:update(dt)
  self.x = self.x - self.speed * dt
end