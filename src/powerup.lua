local PowerUp = {}
PowerUp.__index = PowerUp

PowerUp.types = {"wide", "multiball", "slow", "life", "fast"}

PowerUp.colors = {
    wide      = {0.4, 0.8, 1, 1},
    multiball = {1, 0.8, 0.2, 1},
    slow      = {0.2, 1, 0.4, 1},
    life      = {1, 0.2, 0.8, 1},
    fast      = {1, 0.4, 0.2, 1},
}

function PowerUp.new(type, x, y)
    local self = setmetatable({}, PowerUp)
    self.type = type or "wide"
    self.x = x or 0
    self.y = y or 0
    self.width = 24
    self.height = 24
    self.active = true
    self.speed = 100
    self.color = PowerUp.colors[self.type] or {1, 1, 1, 1}
    return self
end

function PowerUp:update(dt)
    self.y = self.y + self.speed * dt
end

function PowerUp:draw()
    local r, g, b, a = unpack(self.color)
    love.graphics.setColor(r, g, b, a)
    love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.rectangle("line", self.x, self.y, self.width, self.height)

    local font = love.graphics.getFont()
    local text = self.type:sub(1, 1):upper()
    local tw = font:getWidth(text)
    local th = font:getHeight()
    love.graphics.print(text, self.x + (self.width - tw) / 2, self.y + (self.height - th) / 2)
end

function PowerUp:collect(paddle, ball)
    return self.x + self.width >= paddle.x
       and self.x <= paddle.x + paddle.width
       and self.y + self.height >= paddle.y
       and self.y <= paddle.y + paddle.height
end

function PowerUp.applyEffect(type, paddle, ball)
    print("Power-up: " .. type:upper() .. "!")

    if type == "wide" then
        local original = paddle.width
        paddle.width = original * 2
        return function()
            paddle.width = original
            print("Power-up: WIDE expired")
        end, 5

    elseif type == "multiball" then
        -- NOTE: Real multiball requires multiple ball instances.
        -- For now we just increase ball speed as a placeholder.
        local originalVx = ball.vx
        local originalVy = ball.vy
        ball.vx = originalVx * 1.5
        ball.vy = originalVy * 1.5
        return function()
            ball.vx = originalVx
            ball.vy = originalVy
            print("Power-up: MULTIBALL expired")
        end, 5

    elseif type == "slow" then
        local originalVx = ball.vx
        local originalVy = ball.vy
        ball.vx = originalVx * 0.5
        ball.vy = originalVy * 0.5
        return function()
            ball.vx = originalVx
            ball.vy = originalVy
            print("Power-up: SLOW expired")
        end, 5

    elseif type == "fast" then
        local originalVx = ball.vx
        local originalVy = ball.vy
        ball.vx = originalVx * 2
        ball.vy = originalVy * 2
        return function()
            ball.vx = originalVx
            ball.vy = originalVy
            print("Power-up: FAST expired")
        end, 5

    elseif type == "life" then
        lives = lives + 1
        return nil, 0
    end

    return nil, 0
end

return PowerUp
