local Health = {}
Health.__index = Health

function Health.new(max_hp)
    local self = setmetatable({}, Health)
    self.max_hp = max_hp or 10
    self.current_hp = self.max_hp
    return self
end

function Health:take_damage(amount)
    amount = amount or 0
    self.current_hp = math.max(0, self.current_hp - amount)
    return amount
end

function Health:is_alive()
    return self.current_hp > 0
end

return Health
