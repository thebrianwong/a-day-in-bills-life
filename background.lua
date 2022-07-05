Background = Entity:extend()

function Background:new(x, y)
  Background.super.new(self, x, y, "assets/images/background.png")
end