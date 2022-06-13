Goomba = Entity:extend()

function Goomba:new(x, y)
  Player.super.new(self, x, y, "goomba.png")
  self.speed = 50
end
  
function Goomba:update(dt)
  self.x = self.x - self.speed * dt
end
-- work on rotating goomba