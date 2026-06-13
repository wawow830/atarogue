local Brick = {}
Brick.__index = Brick

function Brick.new(x, y, width, height, color)
    local self = setmetatable({}, Brick)
    self.x = x or 0
    self.y = y or 0
    self.width = width or 80
    self.height = height or 24
    self.color = color or {1, 1, 1, 1}
    self.active = true
    return self
end

function Brick:hit()
    self.active = false
    return 10
end

function Brick:draw()
    if not self.active then return end
    love.graphics.setColor(self.color)
    love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
    love.graphics.setColor(1, 1, 1, 1)
end

return Brick
