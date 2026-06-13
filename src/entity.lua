local Entity = {}
Entity.__index = Entity

function Entity.new()
    return setmetatable({ components = {} }, Entity)
end

function Entity:get_component(name)
    return self.components[name]
end

return Entity
