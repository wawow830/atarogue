local Events = {}
Events.__index = Events

-- Shared singleton instance for the game
local shared = nil

function Events.new()
    local self = setmetatable({}, Events)
    self._listeners = {}
    return self
end

function Events.shared()
    if not shared then
        shared = Events.new()
    end
    return shared
end

function Events:clear()
    self._listeners = {}
end

function Events:emit(event, ...)
    local listeners = self._listeners[event]
    if not listeners then
        return
    end
    -- Copy list so removals during iteration are safe
    local copy = {}
    for i = 1, #listeners do
        copy[i] = listeners[i]
    end
    for i = 1, #copy do
        local cb = copy[i]
        if cb then
            cb(...)
        end
    end
    -- Compact nils left by :off during emit
    local compacted = {}
    for i = 1, #listeners do
        if listeners[i] then
            compacted[#compacted + 1] = listeners[i]
        end
    end
    self._listeners[event] = compacted
end

function Events:on(event, callback)
    if not self._listeners[event] then
        self._listeners[event] = {}
    end
    local listeners = self._listeners[event]
    listeners[#listeners + 1] = callback
    return callback
end

function Events:once(event, callback)
    local wrapper
    wrapper = function(...)
        self:off(event, wrapper)
        callback(...)
    end
    self:on(event, wrapper)
    return wrapper
end

function Events:off(event, callback)
    local listeners = self._listeners[event]
    if not listeners then
        return
    end
    for i = 1, #listeners do
        if listeners[i] == callback then
            listeners[i] = nil
            break
        end
    end
end

return Events
