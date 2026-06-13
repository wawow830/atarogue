local Events = {}

local listeners = {}

function Events.on(event, callback)
    assert(type(event) == "string", "event must be a string")
    assert(type(callback) == "function", "callback must be a function")

    if not listeners[event] then
        listeners[event] = {}
    end

    table.insert(listeners[event], callback)
    return callback
end

function Events.off(event, callback)
    assert(type(event) == "string", "event must be a string")
    assert(type(callback) == "function", "callback must be a function")

    local callbacks = listeners[event]
    if not callbacks then
        return false
    end

    for i = #callbacks, 1, -1 do
        if callbacks[i] == callback then
            table.remove(callbacks, i)

            if #callbacks == 0 then
                listeners[event] = nil
            end

            return true
        end
    end

    return false
end

function Events.emit(event, data)
    assert(type(event) == "string", "event must be a string")

    local callbacks = listeners[event]
    if not callbacks then
        return 0
    end

    local snapshot = {}
    for i = 1, #callbacks do
        snapshot[i] = callbacks[i]
    end

    for _, callback in ipairs(snapshot) do
        callback(data)
    end

    return #snapshot
end

return Events
