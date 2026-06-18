local Persistence = {}

local SAVE_FILE = "savegame.lua"
local HIGH_SCORE_FILE = "highscores.lua"
local HIGH_SCORE_LIMIT = 10

local function isArray(t)
    local count = 0
    local max = 0
    for key, _ in pairs(t) do
        if type(key) ~= "number" or key < 1 or key % 1 ~= 0 then
            return false
        end
        count = count + 1
        if key > max then
            max = key
        end
    end
    return max == count
end

local function serialize(value, indent)
    indent = indent or ""
    local valueType = type(value)

    if valueType == "number" or valueType == "boolean" then
        return tostring(value)
    elseif valueType == "string" then
        return string.format("%q", value)
    elseif valueType ~= "table" then
        return "nil"
    end

    local nextIndent = indent .. "    "
    local pieces = {"{"}

    if isArray(value) then
        for _, item in ipairs(value) do
            table.insert(pieces, "\n" .. nextIndent .. serialize(item, nextIndent) .. ",")
        end
    else
        local keys = {}
        for key, _ in pairs(value) do
            if type(key) == "string" or type(key) == "number" then
                table.insert(keys, key)
            end
        end
        table.sort(keys, function(a, b) return tostring(a) < tostring(b) end)

        for _, key in ipairs(keys) do
            local encodedKey
            if type(key) == "string" and key:match("^[_%a][_%w]*$") then
                encodedKey = key
            else
                encodedKey = "[" .. serialize(key, nextIndent) .. "]"
            end
            table.insert(pieces, "\n" .. nextIndent .. encodedKey .. " = " .. serialize(value[key], nextIndent) .. ",")
        end
    end

    table.insert(pieces, "\n" .. indent .. "}")
    return table.concat(pieces)
end

local function cloneSerializable(value, seen)
    local valueType = type(value)
    if valueType == "number" or valueType == "string" or valueType == "boolean" then
        return value
    elseif valueType ~= "table" then
        return nil
    end

    seen = seen or {}
    if seen[value] then
        return nil
    end
    seen[value] = true

    local copy = {}
    for key, item in pairs(value) do
        local keyType = type(key)
        if keyType == "number" or keyType == "string" then
            local cloned = cloneSerializable(item, seen)
            if cloned ~= nil then
                copy[key] = cloned
            end
        end
    end
    seen[value] = nil
    return copy
end

local function writeFile(path, contents)
    if love and love.filesystem then
        return love.filesystem.write(path, contents)
    end

    local file, err = io.open(path, "w")
    if not file then
        return false, err
    end
    file:write(contents)
    file:close()
    return true
end

local function loadFile(path)
    if love and love.filesystem then
        if not love.filesystem.getInfo(path) then
            return nil, "missing"
        end
        local chunk, err = love.filesystem.load(path)
        if not chunk then
            return nil, err
        end
        local ok, data = pcall(chunk)
        if not ok then
            return nil, data
        end
        return data
    end

    local chunk, err = loadfile(path)
    if not chunk then
        return nil, err
    end
    local ok, data = pcall(chunk)
    if not ok then
        return nil, data
    end
    return data
end

local function entitySnapshot(entity, keys)
    if not entity then
        return nil
    end
    local snapshot = {}
    for _, key in ipairs(keys) do
        if entity[key] ~= nil then
            snapshot[key] = cloneSerializable(entity[key])
        end
    end
    return snapshot
end

local function restoreMetatableList(items, moduleName, factoryName)
    if type(items) ~= "table" then
        return items
    end

    local ok, module = pcall(require, moduleName)
    if not ok or type(module) ~= "table" then
        return items
    end

    for index, item in ipairs(items) do
        if type(item) == "table" then
            if factoryName and module[factoryName] then
                items[index] = module[factoryName](item)
            else
                setmetatable(item, module)
            end
        end
    end
    return items
end

function Persistence.buildGameState(source)
    source = source or _G

    local levelState = source.level
    if type(levelState) == "table" and levelState.toSaveData then
        levelState = levelState:toSaveData()
    else
        levelState = cloneSerializable(levelState) or 1
    end

    local brickState = source.bricks or source.brickState
    if not brickState and type(source.level) == "table" and source.level.toSaveData then
        local levelData = source.level:toSaveData()
        brickState = levelData.bricks
    end

    return {
        version = 1,
        savedAt = os.time(),
        score = source.score or 0,
        lives = source.lives or 3,
        gameOver = source.gameOver or false,
        level = levelState,
        -- TICKET-013 compatibility: preserve both simple score and richer scoring table/level score.
        scoring = cloneSerializable(source.scoring or source.scoreState or source.scoreData) or {
            score = source.score or (type(source.level) == "table" and source.level.score) or 0,
            highScore = source.highScore or 0,
            combo = source.combo or 0,
            multiplier = source.multiplier or 1,
        },
        ball = entitySnapshot(source.ball, {"x", "y", "vx", "vy", "radius", "speed", "previousX", "previousY"}),
        paddle = entitySnapshot(source.paddle, {"x", "y", "width", "height", "speed"}),
        -- TICKET-013 brick state is intentionally pass-through so worker fields survive merges.
        bricks = cloneSerializable(brickState),
        lastBrickHit = cloneSerializable(source.lastBrickHit),
        -- TICKET-014 compatibility: persist falling power-up instances exactly as implemented.
        powerUps = cloneSerializable(source.powerUps or source.powerups or source.activePowerUps or source.powerUpState),
    }
end

function Persistence.applyGameState(target, state)
    if not state then
        return false
    end
    target = target or _G

    target.score = state.score or (state.scoring and state.scoring.score) or target.score or 0
    target.lives = state.lives or target.lives or 3
    target.gameOver = state.gameOver or false
    if type(target.level) == "table" and target.level.fromSaveData and type(state.level) == "table" then
        target.level:fromSaveData(state.level)
    else
        target.level = state.level or target.level or 1
    end
    target.scoring = cloneSerializable(state.scoring)
    target.bricks = restoreMetatableList(cloneSerializable(state.bricks), "src.brick", "fromSaveData")
    target.lastBrickHit = cloneSerializable(state.lastBrickHit)
    target.powerUps = restoreMetatableList(cloneSerializable(state.powerUps), "src.powerup")
    target.powerups = target.powerUps
    target.activePowerUps = target.powerUps
    target.powerUpState = target.powerUps

    if target.ball and state.ball then
        for key, value in pairs(state.ball) do
            target.ball[key] = value
        end
    end

    if target.paddle and state.paddle then
        for key, value in pairs(state.paddle) do
            target.paddle[key] = value
        end
    end

    return true
end

function Persistence.saveGame(state, path)
    path = path or SAVE_FILE
    local snapshot = state and cloneSerializable(state) or Persistence.buildGameState(_G)
    return writeFile(path, "return " .. serialize(snapshot) .. "\n")
end

function Persistence.loadGame(path)
    return loadFile(path or SAVE_FILE)
end

function Persistence.loadHighScores(path)
    local scores = loadFile(path or HIGH_SCORE_FILE)
    if type(scores) ~= "table" then
        return {}
    end
    return scores
end

function Persistence.saveHighScores(scores, path)
    return writeFile(path or HIGH_SCORE_FILE, "return " .. serialize(cloneSerializable(scores) or {}) .. "\n")
end

function Persistence.addHighScore(scores, name, score, extra)
    scores = scores or {}
    score = tonumber(score) or 0
    table.insert(scores, {
        name = name or "Player",
        score = score,
        date = os.date("%Y-%m-%d"),
        extra = cloneSerializable(extra),
    })
    table.sort(scores, function(a, b)
        return (tonumber(a.score) or 0) > (tonumber(b.score) or 0)
    end)
    while #scores > HIGH_SCORE_LIMIT do
        table.remove(scores)
    end
    return scores
end

Persistence.SAVE_FILE = SAVE_FILE
Persistence.HIGH_SCORE_FILE = HIGH_SCORE_FILE
Persistence.HIGH_SCORE_LIMIT = HIGH_SCORE_LIMIT
Persistence.serialize = serialize

return Persistence
