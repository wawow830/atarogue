local PowerUp = {}
PowerUp.__index = PowerUp

PowerUp.TYPES = {
    expand_paddle = {
        id = "expand_paddle",
        label = "WIDE",
        color = {0.30, 0.85, 1.00, 1},
        weight = 5,
    },
    slow_ball = {
        id = "slow_ball",
        label = "SLOW",
        color = {0.40, 1.00, 0.45, 1},
        weight = 4,
    },
    extra_life = {
        id = "extra_life",
        label = "+1",
        color = {1.00, 0.25, 0.55, 1},
        weight = 1,
    },
}

PowerUp.DROP_CHANCE = 0.30

local function copyColor(color)
    return {color[1], color[2], color[3], color[4] or 1}
end

local function chooseType(rng)
    rng = rng or love.math.random
    local totalWeight = 0
    for _, definition in pairs(PowerUp.TYPES) do
        totalWeight = totalWeight + definition.weight
    end

    local roll = rng() * totalWeight
    for _, definition in pairs(PowerUp.TYPES) do
        roll = roll - definition.weight
        if roll <= 0 then
            return definition.id
        end
    end

    return "expand_paddle"
end

function PowerUp.getType(typeId)
    return PowerUp.TYPES[typeId or "expand_paddle"] or PowerUp.TYPES.expand_paddle
end

function PowerUp.new(x, y, typeId)
    local definition = PowerUp.getType(typeId)
    local self = setmetatable({}, PowerUp)
    self.x = x or 0
    self.y = y or 0
    self.width = 54
    self.height = 18
    self.vy = 110
    self.type = definition.id
    self.active = true
    return self
end

function PowerUp.newFromBrick(brick, typeId)
    return PowerUp.new(
        brick.x + brick.width / 2 - 27,
        brick.y + brick.height / 2 - 9,
        typeId
    )
end

function PowerUp.rollFromBrick(brick, rng)
    rng = rng or love.math.random
    if not brick or rng() > PowerUp.DROP_CHANCE then
        return nil
    end
    return PowerUp.newFromBrick(brick, chooseType(rng))
end

function PowerUp:update(dt)
    self.y = self.y + self.vy * dt
end

function PowerUp:isOffscreen(screenHeight)
    return self.y > screenHeight
end

function PowerUp:collidesWithPaddle(paddle)
    return self.x < paddle.x + paddle.width
        and self.x + self.width > paddle.x
        and self.y < paddle.y + paddle.height
        and self.y + self.height > paddle.y
end

function PowerUp:apply(game)
    if self.type == "expand_paddle" and game.paddle then
        game.paddle.width = math.min((game.paddle.width or 80) + 24, 160)
    elseif self.type == "slow_ball" and game.ball then
        game.ball.vx = game.ball.vx * 0.85
        game.ball.vy = game.ball.vy * 0.85
    elseif self.type == "extra_life" then
        game.lives = (game.lives or 0) + 1
    end
end

function PowerUp:draw()
    local definition = PowerUp.getType(self.type)
    love.graphics.setColor(copyColor(definition.color))
    love.graphics.rectangle("fill", self.x, self.y, self.width, self.height, 4, 4)
    love.graphics.setColor(0, 0, 0, 0.45)
    love.graphics.rectangle("line", self.x, self.y, self.width, self.height, 4, 4)
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.print(definition.label, self.x + 6, self.y + 3)
end

return PowerUp
