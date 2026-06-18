local Enemy = require("src.enemy")

local EnemySpawner = {}
EnemySpawner.__index = EnemySpawner

function EnemySpawner.new(screenWidth, screenHeight)
    local self = setmetatable({}, EnemySpawner)
    self.screenWidth = screenWidth or 800
    self.screenHeight = screenHeight or 600
    self.enemies = {}
    self.spawnInterval = 2.5
    self.spawnTimer = 1.0
    return self
end

function EnemySpawner:spawn()
    local enemyWidth = 24
    local maxX = math.max(0, self.screenWidth - enemyWidth)
    local x = love.math.random(0, maxX)
    table.insert(self.enemies, Enemy.new(x, -20))
end

local function damagePlayer(playerHealth, amount)
    if playerHealth and playerHealth.damage then
        return playerHealth:damage(amount)
    end

    -- Compatibility for the pre-health-system branch. TICKET-011 provides
    -- playerHealth:damage(amount); this keeps this ticket playable by itself.
    if lives then
        lives = math.max(0, lives - (amount or 1))
        return true
    end

    return false
end

function EnemySpawner:update(dt, player, playerHealth)
    self.spawnTimer = self.spawnTimer - dt
    if self.spawnTimer <= 0 then
        self:spawn()
        self.spawnTimer = self.spawnInterval
    end

    for i = #self.enemies, 1, -1 do
        local enemy = self.enemies[i]
        enemy:update(dt)

        if player and enemy:intersects(player) then
            damagePlayer(playerHealth, enemy.damage)
            table.remove(self.enemies, i)
        elseif enemy.y > self.screenHeight then
            table.remove(self.enemies, i)
        end
    end
end

function EnemySpawner:draw()
    for _, enemy in ipairs(self.enemies) do
        enemy:draw()
    end
end

return EnemySpawner
