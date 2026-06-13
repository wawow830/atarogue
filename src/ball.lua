local Ball = {}
Ball.__index = Ball

function Ball.new(x, y)
    local self = setmetatable({}, Ball)
    self.x = x or 0
    self.y = y or 0
    self.vx = 0
    self.vy = 0
    self.radius = 8
    return self
end

function Ball:update(dt)
    self.x = self.x + self.vx * dt
    self.y = self.y + self.vy * dt
end

function Ball:draw()
    love.graphics.circle("fill", self.x, self.y, self.radius or 8)
end

return Ball
