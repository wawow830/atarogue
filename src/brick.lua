local Brick = {}
Brick.__index = Brick

Brick.TYPES = {
    basic = {
        id = "basic",
        name = "Basic",
        hp = 1,
        score = 100,
        color = {0.85, 0.25, 0.20, 1},
    },
    tough = {
        id = "tough",
        name = "Tough",
        hp = 2,
        score = 250,
        color = {0.95, 0.60, 0.15, 1},
        damagedColor = {0.95, 0.85, 0.20, 1},
    },
    crystal = {
        id = "crystal",
        name = "Crystal",
        hp = 1,
        score = 400,
        color = {0.25, 0.80, 1.00, 1},
    },
    stone = {
        id = "stone",
        name = "Stone",
        hp = 3,
        score = 500,
        color = {0.45, 0.45, 0.55, 1},
        damagedColor = {0.65, 0.65, 0.72, 1},
    },
    steel = {
        id = "steel",
        name = "Steel",
        hp = 999,
        score = 0,
        color = {0.25, 0.25, 0.30, 1},
        indestructible = true,
    },
}

local function copyColor(color)
    return {color[1], color[2], color[3], color[4] or 1}
end

function Brick.getType(typeId)
    return Brick.TYPES[typeId or "basic"] or Brick.TYPES.basic
end

function Brick.new(x, y, width, height, typeId)
    local definition = Brick.getType(typeId)
    local self = setmetatable({}, Brick)
    self.x = x or 0
    self.y = y or 0
    self.width = width or 64
    self.height = height or 22
    self.type = definition.id
    self.maxHp = definition.hp
    self.hp = definition.hp
    self.score = definition.score
    self.indestructible = definition.indestructible or false
    self.destroyed = false
    return self
end

function Brick:isAlive()
    return not self.destroyed
end

function Brick:isBreakable()
    return not self.indestructible
end

function Brick:hit(damage)
    damage = damage or 1

    if self.destroyed then
        return {hit = false, destroyed = false, score = 0, brick = self}
    end

    if self.indestructible then
        return {hit = true, destroyed = false, score = 0, brick = self}
    end

    self.hp = math.max(0, self.hp - damage)
    if self.hp <= 0 then
        self.destroyed = true
        return {hit = true, destroyed = true, score = self.score, brick = self}
    end

    return {hit = true, destroyed = false, score = 0, brick = self}
end

function Brick:getColor()
    local definition = Brick.getType(self.type)
    if self.hp < self.maxHp and definition.damagedColor then
        return copyColor(definition.damagedColor)
    end
    return copyColor(definition.color)
end

function Brick:draw()
    if self.destroyed then
        return
    end

    local color = self:getColor()
    love.graphics.setColor(color[1], color[2], color[3], color[4])
    love.graphics.rectangle("fill", self.x, self.y, self.width, self.height, 4, 4)
    love.graphics.setColor(0, 0, 0, 0.35)
    love.graphics.rectangle("line", self.x, self.y, self.width, self.height, 4, 4)
    love.graphics.setColor(1, 1, 1, 1)

    if self.maxHp > 1 and not self.indestructible then
        love.graphics.print(tostring(self.hp), self.x + self.width / 2 - 3, self.y + 3)
    end
end

function Brick:toSaveData()
    return {
        x = self.x,
        y = self.y,
        width = self.width,
        height = self.height,
        type = self.type,
        hp = self.hp,
        destroyed = self.destroyed,
    }
end

function Brick.fromSaveData(data)
    local brick = Brick.new(data.x, data.y, data.width, data.height, data.type)
    brick.hp = data.hp or brick.hp
    brick.destroyed = data.destroyed or false
    return brick
end

return Brick
