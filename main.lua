local Ball = require("src.ball")
local Paddle = require("src.paddle")
local Level = require("src.level")

local function resetBall()
    local screenWidth = love.graphics.getWidth()
    local screenHeight = love.graphics.getHeight()
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
    ball.radius = 8
    ball.vx = 200
    ball.vy = -250

    level = Level.new(screenWidth)
    score = 0
    lives = 3
    gameOver = false
    lastBrickHit = nil
end

function love.update(dt)
    if gameOver then
        return
    end

    ball.previousX = ball.x
    ball.previousY = ball.y

    ball:update(dt)
    paddle:update(dt)
    level:update(dt)

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

    local brickHit = level:handleBallCollision(ball)
    if brickHit then
        lastBrickHit = brickHit
        score = level.score
    end

    if level:isCleared() then
        level:advance()
        score = level.score
        resetBall()
    end
end

function love.draw()
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.print("Atarogue", 10, 10)
    love.graphics.print("Score: " .. score, 10, 30)
    love.graphics.print("Lives: " .. lives, 10, 50)
    love.graphics.print("Level " .. level.number .. ": " .. level.name, 620, 10)
    love.graphics.print("Bricks: " .. level:remainingBreakableBricks(), 620, 30)

    if lastBrickHit and lastBrickHit.destroyed then
        love.graphics.print("+" .. lastBrickHit.score .. " " .. lastBrickHit.brickType, 620, 50)
    end

    level:draw()
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
