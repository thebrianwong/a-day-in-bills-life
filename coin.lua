Coin = Entity:extend()

function Coin:new(x, y)
  Coin.super.new(self, x, y, "coin.png")
end
  
function Coin:update(dt)
  self.x = self.x - self.speed * dt
end