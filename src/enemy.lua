local Enemy = {}
Enemy.__index = Enemy

function Enemy.new(x, y)
    local self = setmetatable({}, Enemy)
    self.x = x or 0
    self.y = y or 0
    self.width = 24
    self.height = 18
    self.speed = 95
    self.damage = 1
    self.active = true
    return self
end

function Enemy:update(dt)
    self.y = self.y + self.speed * dt
end

function Enemy:intersects(rect)
    return self.x < rect.x + rect.width
        and self.x + self.width > rect.x
        and self.y < rect.y + rect.height
        and self.y + self.height > rect.y
end

function Enemy:draw()
    local oldR, oldG, oldB, oldA = love.graphics.getColor()
    love.graphics.setColor(0.8, 0.15, 0.85, 1)
    love.graphics.rectangle("fill", self.x, self.y, self.width, self.height, 4, 4)
    love.graphics.setColor(0.2, 0.05, 0.25, 1)
    love.graphics.rectangle("line", self.x, self.y, self.width, self.height, 4, 4)
    love.graphics.setColor(oldR, oldG, oldB, oldA)
end

return Enemy
