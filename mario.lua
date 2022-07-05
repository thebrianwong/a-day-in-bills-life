Mario = Entity:extend()

function Mario:new(x, y)
  Mario.super.new(self, x, y, "assets/images/mario.png")
end