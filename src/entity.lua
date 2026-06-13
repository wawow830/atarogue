local Entity = {}

local next_id = 0

function Entity.create_entity()
    next_id = next_id + 1

    return {
        id = next_id,
        components = {}
    }
end

function Entity.add_component(entity, name, component)
    if not entity.components then
        entity.components = {}
    end

    entity.components[name] = component
    return component
end

function Entity.get_component(entity, name)
    if not entity.components then
        return nil
    end

    return entity.components[name]
end

return Entity
