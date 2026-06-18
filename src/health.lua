local Health = {}
Health.__index = Health

local DEFAULT_MAX_HEARTS = 3
local DEFAULT_INVULNERABILITY = 1.0
local HEART_SIZE = 18
local HEART_SPACING = 6

function Health.new(maxHearts)
    local self = setmetatable({}, Health)
    self.maxHearts = maxHearts or DEFAULT_MAX_HEARTS
    self.currentHearts = self.maxHearts
    self.invulnerabilityDuration = DEFAULT_INVULNERABILITY
    self.invulnerabilityTimer = 0
    return self
end

function Health:update(dt)
    if self.invulnerabilityTimer > 0 then
        self.invulnerabilityTimer = math.max(0, self.invulnerabilityTimer - dt)
    end
end

function Health:isInvulnerable()
    return self.invulnerabilityTimer > 0
end

function Health:damage(amount)
    amount = amount or 1

    if amount <= 0 or self:isInvulnerable() or self:isDead() then
        return false
    end

    self.currentHearts = math.max(0, self.currentHearts - amount)
    self.invulnerabilityTimer = self.invulnerabilityDuration
    return true
end

function Health:heal(amount)
    amount = amount or 1

    if amount <= 0 or self:isDead() then
        return false
    end

    local previousHearts = self.currentHearts
    self.currentHearts = math.min(self.maxHearts, self.currentHearts + amount)
    return self.currentHearts ~= previousHearts
end

function Health:reset()
    self.currentHearts = self.maxHearts
    self.invulnerabilityTimer = 0
end

function Health:isDead()
    return self.currentHearts <= 0
end

local function setColor(color)
    love.graphics.setColor(color.r, color.g, color.b, color.a)
end

local function drawHeart(mode, x, y, size)
    local radius = size / 4
    local leftLobeX = x + radius
    local rightLobeX = x + size - radius
    local lobeY = y + radius
    local pointY = y + size

    love.graphics.circle(mode, leftLobeX, lobeY, radius)
    love.graphics.circle(mode, rightLobeX, lobeY, radius)
    love.graphics.polygon(mode,
        x, y + size / 3,
        x + size, y + size / 3,
        x + size / 2, pointY
    )
end

function Health:draw(x, y)
    x = x or 10
    y = y or 50

    local fullColor = {r = 1, g = 0.12, b = 0.18, a = 1}
    local emptyColor = {r = 0.25, g = 0.25, b = 0.25, a = 1}
    local oldR, oldG, oldB, oldA = love.graphics.getColor()

    love.graphics.print("Health:", x, y)

    for i = 1, self.maxHearts do
        local heartX = x + 58 + (i - 1) * (HEART_SIZE + HEART_SPACING)
        local heartY = y + 2

        if i <= self.currentHearts then
            setColor(fullColor)
            drawHeart("fill", heartX, heartY, HEART_SIZE)
        else
            setColor(emptyColor)
            drawHeart("line", heartX, heartY, HEART_SIZE)
        end
    end

    love.graphics.setColor(oldR, oldG, oldB, oldA)
end

return Health
