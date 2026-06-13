local Events = require("src.events")
local Entity = require("src.entity")

local Combat = {}

function Combat.dodge_chance(attacker, defender)
    return math.random() < 0.25
end

function Combat.attack(attacker, defender)
    local attack_power = attacker and attacker.components and attacker.components.attack or 1

    local health = Entity.get_component(defender, "health")
    if not health then
        Events.emit("combat.miss", { attacker = attacker, defender = defender, reason = "no_health" })
        return 0
    end

    if not health:is_alive() then
        Events.emit("combat.miss", { attacker = attacker, defender = defender, reason = "dead" })
        return 0
    end

    if Combat.dodge_chance(attacker, defender) then
        Events.emit("combat.miss", { attacker = attacker, defender = defender, reason = "dodged" })
        return 0
    end

    local damage = health:take_damage(attack_power)
    local remaining = health.current_hp

    Events.emit("combat.hit", { attacker = attacker, defender = defender, damage = damage, remaining = remaining })

    if remaining <= 0 then
        Events.emit("combat.kill", { attacker = attacker, defender = defender, damage = damage })
    end

    return damage
end

function Combat.deal_damage(defender, amount)
    local health = Entity.get_component(defender, "health")
    if not health then
        Events.emit("combat.miss", { attacker = nil, defender = defender, reason = "no_health" })
        return 0
    end

    if not health:is_alive() then
        Events.emit("combat.miss", { attacker = nil, defender = defender, reason = "dead" })
        return 0
    end

    local damage = health:take_damage(amount)
    local remaining = health.current_hp

    Events.emit("combat.hit", { attacker = nil, defender = defender, damage = damage, remaining = remaining })

    if remaining <= 0 then
        Events.emit("combat.kill", { attacker = nil, defender = defender, damage = damage })
    end

    return damage
end

return Combat
