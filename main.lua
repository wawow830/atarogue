local Ball = require("src.ball")
local Paddle = require("src.paddle")

function love.load()
    -- Atarogue: a roguelike Atari Breakout
    print("Atarogue loaded!")

    local screenWidth = love.graphics.getWidth()
    local screenHeight = love.graphics.getHeight()

    paddle = Paddle.new(screenWidth / 2 - 40, screenHeight - 40)
    ball = Ball.new(screenWidth / 2, screenHeight - 60)
    ball.vx = 200
    ball.vy = -250
end

function love.update(dt)
    ball:update(dt)
    paddle:update(dt)

    local screenWidth = love.graphics.getWidth()
    local screenHeight = love.graphics.getHeight()

    -- Paddle screen bounds
    if paddle.x < 0 then
        paddle.x = 0
    elseif paddle.x + paddle.width > screenWidth then
        paddle.x = screenWidth - paddle.width
    end

    -- Ball bounce off left/right/top edges
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

    -- Ball falls off bottom: reset
    if ball.y - 8 > screenHeight then
        ball.x = screenWidth / 2
        ball.y = screenHeight - 60
        ball.vx = 200
        ball.vy = -250
    end

    -- Ball-paddle collision (AABB vs circle approximation)
    if ball.y + 8 >= paddle.y and ball.y - 8 <= paddle.y + paddle.height then
        if ball.x >= paddle.x and ball.x <= paddle.x + paddle.width then
            ball.y = paddle.y - 8
            ball.vy = -math.abs(ball.vy)
        end
    end
end

function love.draw()
    love.graphics.print("Atarogue", 10, 10)
    ball:draw()
    paddle:draw()
end
