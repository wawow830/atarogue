local Brick = require("src.brick")

local Level = {}
Level.__index = Level

local DEFAULT_BRICK_WIDTH = 68
local DEFAULT_BRICK_HEIGHT = 22
local DEFAULT_GAP = 8
local TOP_OFFSET = 78

local LEVEL_PATTERNS = {
    {
        name = "The Approach",
        rows = {
            "bbbbbbbb",
            "bttttttb",
            "cccccccc",
            "bbbbbbbb",
        },
    },
    {
        name = "Iron Teeth",
        rows = {
            "ttccctt",
            "bbsssbb",
            "ccbbbcc",
            "ttccctt",
            "bbbbbbb",
        },
    },
    {
        name = "The Gate",
        rows = {
            "ssstsss",
            "cxxbxxc",
            "ttcccct",
            "bbsssbb",
            "ccccccc",
        },
    },
}

local TYPE_BY_SYMBOL = {
    b = "basic",
    t = "tough",
    c = "crystal",
    s = "stone",
    x = "steel",
}

local function clamp(value, min, max)
    if value < min then return min end
    if value > max then return max end
    return value
end

local function circleIntersectsRect(cx, cy, radius, rect)
    local closestX = clamp(cx, rect.x, rect.x + rect.width)
    local closestY = clamp(cy, rect.y, rect.y + rect.height)
    local dx = cx - closestX
    local dy = cy - closestY
    return dx * dx + dy * dy <= radius * radius, closestX, closestY
end

function Level.new(screenWidth)
    local self = setmetatable({}, Level)
    self.screenWidth = screenWidth or 800
    self.number = 1
    self.name = ""
    self.bricks = {}
    self.score = 0
    self.clearBonus = 1000
    self:load(self.number)
    return self
end

function Level:load(number)
    self.number = number or self.number or 1
    local pattern = LEVEL_PATTERNS[((self.number - 1) % #LEVEL_PATTERNS) + 1]
    self.name = pattern.name
    self.bricks = {}

    local rowWidth = #pattern.rows[1] * DEFAULT_BRICK_WIDTH + (#pattern.rows[1] - 1) * DEFAULT_GAP
    local startX = math.floor((self.screenWidth - rowWidth) / 2)

    for rowIndex, row in ipairs(pattern.rows) do
        for column = 1, #row do
            local symbol = row:sub(column, column)
            local typeId = TYPE_BY_SYMBOL[symbol]
            if typeId then
                local x = startX + (column - 1) * (DEFAULT_BRICK_WIDTH + DEFAULT_GAP)
                local y = TOP_OFFSET + (rowIndex - 1) * (DEFAULT_BRICK_HEIGHT + DEFAULT_GAP)
                table.insert(self.bricks, Brick.new(x, y, DEFAULT_BRICK_WIDTH, DEFAULT_BRICK_HEIGHT, typeId))
            end
        end
    end
end

function Level:update(dt)
    -- Reserved for animated/regenerating brick types. Kept for API symmetry.
end

function Level:draw()
    for _, brick in ipairs(self.bricks) do
        brick:draw()
    end
end

function Level:remainingBreakableBricks()
    local count = 0
    for _, brick in ipairs(self.bricks) do
        if brick:isAlive() and brick:isBreakable() then
            count = count + 1
        end
    end
    return count
end

function Level:isCleared()
    return self:remainingBreakableBricks() == 0
end

function Level:advance()
    self.score = self.score + self.clearBonus * self.number
    self:load(self.number + 1)
    return self.number
end

function Level:handleBallCollision(ball)
    local radius = ball.radius or 8

    for _, brick in ipairs(self.bricks) do
        if brick:isAlive() then
            local collided = circleIntersectsRect(ball.x, ball.y, radius, brick)
            if collided then
                local previousX = ball.previousX or ball.x
                local previousY = ball.previousY or ball.y

                if previousY + radius <= brick.y or previousY - radius >= brick.y + brick.height then
                    ball.vy = -(ball.vy or 0)
                elseif previousX + radius <= brick.x or previousX - radius >= brick.x + brick.width then
                    ball.vx = -(ball.vx or 0)
                else
                    ball.vy = -(ball.vy or 0)
                end

                local result = brick:hit(1)
                result.level = self.number
                result.brickType = brick.type
                result.x = brick.x + brick.width / 2
                result.y = brick.y + brick.height / 2

                if result.destroyed then
                    self.score = self.score + result.score
                end

                return result
            end
        end
    end

    return nil
end

function Level:toSaveData()
    local bricks = {}
    for index, brick in ipairs(self.bricks) do
        bricks[index] = brick:toSaveData()
    end

    return {
        number = self.number,
        name = self.name,
        score = self.score,
        bricks = bricks,
    }
end

function Level:fromSaveData(data)
    self.number = data.number or 1
    self.name = data.name or ""
    self.score = data.score or 0
    self.bricks = {}

    for _, brickData in ipairs(data.bricks or {}) do
        table.insert(self.bricks, Brick.fromSaveData(brickData))
    end

    if #self.bricks == 0 then
        self:load(self.number)
    end
end

return Level
