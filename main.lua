local Ball = require("src.ball")
local Paddle = require("src.paddle")
local Persistence = require("src.persistence")

local function resetBall(screenWidth, screenHeight)
    ball.x = screenWidth / 2
    ball.y = screenHeight - 60
    ball.vx = 200
    ball.vy = -250
end

function love.load()
    -- Atarogue: a roguelike Atari Breakout
    print("Atarogue loaded!")

    local screenWidth = love.graphics.getWidth()
    local screenHeight = love.graphics.getHeight()

    paddle = Paddle.new(screenWidth / 2 - 40, screenHeight - 40)
    ball = Ball.new(screenWidth / 2, screenHeight - 60)
    resetBall(screenWidth, screenHeight)
    -- BROWNFIELD: messy globals, no state table
    score = 0
    lives = 3
    level = 1
    highScores = Persistence.loadHighScores()
    saveMessage = "F5 save / F9 load"
    gameOverRecorded = false
    -- Compatibility holders for parallel ticket merges.
    scoring = { score = score, highScore = highScores[1] and highScores[1].score or 0, combo = 0, multiplier = 1 }
    powerUps = powerUps or {}
    -- TODO: powerup system
    -- TODO: brick system
    -- TODO: level progression
    -- FIXME: collision is hacky
end

function love.update(dt)
    if lives <= 0 then
        if not gameOverRecorded then
            highScores = Persistence.addHighScore(highScores, "Player", score, { level = level })
            Persistence.saveHighScores(highScores)
            gameOverRecorded = true
            saveMessage = "Game over! High score saved."
        end
        return
    end

    ball:update(dt)
    paddle:update(dt)

    if scoring then
        scoring.score = score
        scoring.highScore = highScores[1] and highScores[1].score or scoring.highScore or 0
    end

    local screenWidth = love.graphics.getWidth()
    local screenHeight = love.graphics.getHeight()

    -- BROWNFIELD: duplicated logic scattered everywhere
    if paddle.x < 0 then
        paddle.x = 0
    elseif paddle.x + paddle.width > screenWidth then
        paddle.x = screenWidth - paddle.width
    end

    if ball.x - 8 <= 0 then
        ball.x = 8
        ball.vx = math.abs(ball.vx)
    elseif ball.x + 8 >= screenWidth then
        ball.x = screenWidth - 8
        ball.vx = -math.abs(ball.vx)
    end

    if ball.y - 8 <= 0 then
        ball.y = 8
        ball.vy = math.abs(ball.vy)
    end

    if ball.y - 8 > screenHeight then
        resetBall(screenWidth, screenHeight)
        lives = lives - 1
        -- TODO: game over screen
    end

    if ball.y + 8 >= paddle.y and ball.y - 8 <= paddle.y + paddle.height then
        if ball.x >= paddle.x and ball.x <= paddle.x + paddle.width then
            ball.y = paddle.y - 8
            ball.vy = -math.abs(ball.vy)
        end
    end
end

function love.draw()
    love.graphics.print("Atarogue", 10, 10)
    -- BROWNFIELD: magic numbers everywhere
    love.graphics.print("Score: " .. score, 10, 30)
    love.graphics.print("Lives: " .. lives, 10, 50)
    love.graphics.print("High Score: " .. ((highScores[1] and highScores[1].score) or 0), 10, 70)
    love.graphics.print(saveMessage or "", 10, 90)

    love.graphics.print("Top Scores", 650, 10)
    for i = 1, math.min(#highScores, 5) do
        local entry = highScores[i]
        love.graphics.print(i .. ". " .. entry.name .. " " .. entry.score, 650, 10 + i * 20)
    end

    ball:draw()
    paddle:draw()
end

-- BROWNFIELD: dead code
function love.keypressed(key)
    if key == "f5" or key == "s" then
        local ok, err = Persistence.saveGame(Persistence.buildGameState(_G))
        saveMessage = ok and "Game saved" or ("Save failed: " .. tostring(err))
    elseif key == "f9" or key == "l" then
        local saved, err = Persistence.loadGame()
        if saved then
            Persistence.applyGameState(_G, saved)
            highScores = Persistence.loadHighScores()
            gameOverRecorded = lives <= 0
            saveMessage = "Game loaded"
        else
            saveMessage = "Load failed: " .. tostring(err)
        end
    elseif key == "space" then
        -- TODO: pause
    end
end
