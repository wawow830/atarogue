local Score = require("src.score")

local HighScore = {}

local MAX_SCORES = 5
local scores = {}

local function copyScores()
    local copy = {}
    for i, score in ipairs(scores) do
        copy[i] = score
    end
    return copy
end

local function sortScores()
    table.sort(scores, function(a, b)
        return a > b
    end)

    while #scores > MAX_SCORES do
        table.remove(scores)
    end
end

function HighScore.record(score)
    local scoreToRecord = score
    if scoreToRecord == nil then
        scoreToRecord = Score.get()
    end

    assert(type(scoreToRecord) == "number", "score must be a number")

    table.insert(scores, scoreToRecord)
    sortScores()

    return copyScores()
end

function HighScore.recordCurrent()
    return HighScore.record(Score.get())
end

function HighScore.get()
    return copyScores()
end

function HighScore.clear()
    scores = {}
    return copyScores()
end

function HighScore.isHighScore(score)
    assert(type(score) == "number", "score must be a number")

    if #scores < MAX_SCORES then
        return true
    end

    return score > scores[#scores]
end

return HighScore
