local Health = {}
Health.__index = Health

function Health.new(health)
    local self = setmetatable({}, Health)
    self.max_health = health or 1
    self.health = self.max_health
    return self
end

function Health:take_damage(amount)
    amount = amount or 0
    if amount <= 0 then
        return self.health
    end

    self.health = math.max(0, self.health - amount)
    return self.health
end

function Health:heal(amount)
    amount = amount or 0
    if amount <= 0 then
        return self.health
    end

    self.health = math.min(self.max_health, self.health + amount)
    return self.health
end

function Health:is_alive()
    return self.health > 0
end

return Health
