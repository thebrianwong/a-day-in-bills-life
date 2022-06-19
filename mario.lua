Mario = Entity:extend()

function Mario:new(x, y)
  Mario.super.new(self, x, y, "mario.png")
  self.speed = 0
end
  
function Mario:update(dt)
  self.x = self.x - self.speed * dt
end