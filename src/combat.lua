local Events = require("src.events")
local Entity = require("src.entity")
local Health = require("src.health")

local Combat = {}

function Combat.attack(attacker, defender)
    local attack_power = 1
    if attacker and attacker.components and attacker.components.attack then
        attack_power = attacker.components.attack
    end

    local health_component = Entity.get_component(defender, "health")
    if not health_component then
        Events.emit("combat.miss", { attacker = attacker, defender = defender, reason = "no_health" })
        return 0
    end

    if not health_component:is_alive() then
        Events.emit("combat.miss", { attacker = attacker, defender = defender, reason = "dead" })
        return 0
    end

    local damage = attack_power
    local remaining = health_component:take_damage(damage)

    Events.emit("combat.hit", {
        attacker = attacker,
        defender = defender,
        damage = damage,
        remaining = remaining
    })

    if not health_component:is_alive() then
        Events.emit("combat.kill", {
            attacker = attacker,
            defender = defender,
            damage = damage
        })
    end

    return damage
end

function Combat.deal_damage(defender, amount)
    local health_component = Entity.get_component(defender, "health")
    if not health_component then
        Events.emit("combat.miss", { attacker = nil, defender = defender, reason = "no_health" })
        return 0
    end

    if not health_component:is_alive() then
        Events.emit("combat.miss", { attacker = nil, defender = defender, reason = "dead" })
        return 0
    end

    local damage = amount
    local remaining = health_component:take_damage(damage)

    Events.emit("combat.hit", {
        attacker = nil,
        defender = defender,
        damage = damage,
        remaining = remaining
    })

    if not health_component:is_alive() then
        Events.emit("combat.kill", {
            attacker = nil,
            defender = defender,
            damage = damage
        })
    end

    return damage
end

return Combat
