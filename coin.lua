Coin = Entity:extend()

function Coin:new(x, y)
  Coin.super.new(self, x, y, "assets/images/coin.png")
end