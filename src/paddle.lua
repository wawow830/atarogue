local Paddle = {}
Paddle.__index = Paddle

function Paddle.new(x, y)
    local self = setmetatable({}, Paddle)
    self.x = x or 0
    self.y = y or 0
    self.width = 80
    self.height = 16
    self.speed = 300
    return self
end

function Paddle:update(dt)
    if love.keyboard.isDown("left") then
        self.x = self.x - self.speed * dt
    elseif love.keyboard.isDown("right") then
        self.x = self.x + self.speed * dt
    end
end

function Paddle:draw()
    love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
end

return Paddle
