local Particle = {}
Particle.__index = Particle

function Particle.new(x, y, vx, vy, lifetime, color, size)
    local self = setmetatable({}, Particle)
    self.x = x or 0
    self.y = y or 0
    self.vx = vx or 0
    self.vy = vy or 0
    self.lifetime = lifetime or 1
    self.max_lifetime = self.lifetime
    self.color = color or {1, 1, 1, 1}
    self.size = size or 2
    self.alive = true
    return self
end

function Particle:update(dt)
    self.x = self.x + self.vx * dt
    self.y = self.y + self.vy * dt
    self.lifetime = self.lifetime - dt
    self.color[4] = math.max(0, self.lifetime / self.max_lifetime)
    if self.lifetime <= 0 then
        self.alive = false
    end
end

function Particle:draw()
    love.graphics.setColor(self.color)
    love.graphics.circle("fill", self.x, self.y, self.size)
    love.graphics.setColor(1, 1, 1, 1)
end

local ParticleSystem = {}
ParticleSystem.__index = ParticleSystem

function ParticleSystem.new()
    local self = setmetatable({}, ParticleSystem)
    self.particles = {}
    return self
end

function ParticleSystem:emit(x, y, count, color)
    count = count or 10
    color = color or {1, 1, 1, 1}
    for i = 1, count do
        local angle = math.random() * math.pi * 2
        local speed = math.random(50, 200)
        local vx = math.cos(angle) * speed
        local vy = math.sin(angle) * speed
        local lifetime = math.random(3, 8) / 10
        local size = math.random(2, 4)
        local p = Particle.new(x, y, vx, vy, lifetime, {color[1], color[2], color[3], 1}, size)
        table.insert(self.particles, p)
    end
end

function ParticleSystem:update(dt)
    for i = #self.particles, 1, -1 do
        local p = self.particles[i]
        p:update(dt)
        if not p.alive then
            table.remove(self.particles, i)
        end
    end
end

function ParticleSystem:draw()
    for _, p in ipairs(self.particles) do
        p:draw()
    end
end

function ParticleSystem:clear()
    self.particles = {}
end

return ParticleSystem
