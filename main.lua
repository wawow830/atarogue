local Ball = require("src.ball")
local Paddle = require("src.paddle")
local PowerUp = require("src.powerup")

local hasLevel, Level = pcall(require, "src.level")
if not hasLevel then
    Level = nil
end

local function resetBall()
    local screenWidth = love.graphics.getWidth()
    local screenHeight = love.graphics.getHeight()
    ball.x = screenWidth / 2
    ball.y = screenHeight - 60
    ball.vx = 200
    ball.vy = -250
end

function spawnPowerUpFromBrick(brick)
    local powerUp = PowerUp.rollFromBrick(brick)
    if powerUp then
        table.insert(powerUps, powerUp)
    end
    return powerUp
end

function handleBrickBroken(brick)
    return spawnPowerUpFromBrick(brick)
end

function love.load()
    -- Atarogue: a roguelike Atari Breakout
    print("Atarogue loaded!")

    local screenWidth = love.graphics.getWidth()
    local screenHeight = love.graphics.getHeight()

    paddle = Paddle.new(screenWidth / 2 - 40, screenHeight - 40)
    ball = Ball.new(screenWidth / 2, screenHeight - 60)
    ball.radius = ball.radius or 8
    ball.vx = 200
    ball.vy = -250

    level = Level and Level.new(screenWidth) or nil
    score = 0
    lives = 3
    powerUps = {}
    gameOver = false
    lastBrickHit = nil
    lastPowerUp = nil
end

function love.update(dt)
    if gameOver then
        return
    end

    ball.previousX = ball.x
    ball.previousY = ball.y

    ball:update(dt)
    paddle:update(dt)
    if level then
        level:update(dt)
    end

    local screenWidth = love.graphics.getWidth()
    local screenHeight = love.graphics.getHeight()
    local radius = ball.radius or 8

    if paddle.x < 0 then
        paddle.x = 0
    elseif paddle.x + paddle.width > screenWidth then
        paddle.x = screenWidth - paddle.width
    end

    if ball.x - radius <= 0 then
        ball.x = radius
        ball.vx = math.abs(ball.vx)
    elseif ball.x + radius >= screenWidth then
        ball.x = screenWidth - radius
        ball.vx = -math.abs(ball.vx)
    end

    if ball.y - radius <= 0 then
        ball.y = radius
        ball.vy = math.abs(ball.vy)
    end

    if ball.y - radius > screenHeight then
        lives = lives - 1
        if lives <= 0 then
            gameOver = true
        else
            resetBall()
        end
        return
    end

    if ball.y + radius >= paddle.y and ball.y - radius <= paddle.y + paddle.height then
        if ball.x >= paddle.x and ball.x <= paddle.x + paddle.width and ball.vy > 0 then
            local hitOffset = (ball.x - (paddle.x + paddle.width / 2)) / (paddle.width / 2)
            ball.y = paddle.y - radius
            ball.vy = -math.abs(ball.vy)
            ball.vx = hitOffset * 300
        end
    end

    if level then
        local brickHit = level:handleBallCollision(ball)
        if brickHit then
            lastBrickHit = brickHit
            score = level.score
            if brickHit.destroyed then
                lastPowerUp = handleBrickBroken(brickHit.brick)
            end
        end

        if level:isCleared() then
            level:advance()
            score = level.score
            powerUps = {}
            resetBall()
        end
    end

    for i = #powerUps, 1, -1 do
        local powerUp = powerUps[i]
        powerUp:update(dt)
        if powerUp:collidesWithPaddle(paddle) then
            local game = {paddle = paddle, ball = ball, lives = lives}
            powerUp:apply(game)
            lives = game.lives or lives
            lastPowerUp = powerUp
            table.remove(powerUps, i)
        elseif powerUp:isOffscreen(screenHeight) then
            table.remove(powerUps, i)
        end
    end
end

function love.draw()
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.print("Atarogue", 10, 10)
    love.graphics.print("Score: " .. score, 10, 30)
    love.graphics.print("Lives: " .. lives, 10, 50)

    if level then
        love.graphics.print("Level " .. level.number .. ": " .. level.name, 620, 10)
        love.graphics.print("Bricks: " .. level:remainingBreakableBricks(), 620, 30)

        if lastBrickHit and lastBrickHit.destroyed then
            love.graphics.print("+" .. lastBrickHit.score .. " " .. lastBrickHit.brickType, 620, 50)
        end

        level:draw()
    end

    if lastPowerUp then
        love.graphics.print("Power-up: " .. PowerUp.getType(lastPowerUp.type).label, 620, 70)
    end

    for _, powerUp in ipairs(powerUps or {}) do
        powerUp:draw()
    end

    ball:draw()
    paddle:draw()

    if gameOver then
        love.graphics.printf("GAME OVER\nPress R to restart", 0, 260, love.graphics.getWidth(), "center")
    end
end

function love.keypressed(key)
    if key == "r" and gameOver then
        love.load()
    end
end
