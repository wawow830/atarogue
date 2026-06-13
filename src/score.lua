local Score = {}

local currentScore = 0

function Score.add(points)
    currentScore = currentScore + (points or 0)
    return currentScore
end

function Score.get()
    return currentScore
end

function Score.reset()
    currentScore = 0
    return currentScore
end

return Score
