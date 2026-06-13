local Events = {}
Events.listeners = {}

function Events.on(event, callback)
    Events.listeners[event] = Events.listeners[event] or {}
    table.insert(Events.listeners[event], callback)
end

function Events.emit(event, payload)
    local callbacks = Events.listeners[event] or {}
    for _, cb in ipairs(callbacks) do
        cb(payload)
    end
end

return Events
