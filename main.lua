local Ball = require("src.ball")
local Paddle = require("src.paddle")
local Health = require("src.health")

function love.load()
    -- Atarogue: a roguelike Atari Breakout
    print("Atarogue loaded!")

    local screenWidth = love.graphics.getWidth()
    local screenHeight = love.graphics.getHeight()

    paddle = Paddle.new(screenWidth / 2 - 40, screenHeight - 40)
    ball = Ball.new(screenWidth / 2, screenHeight - 60)
    ball.vx = 200
    ball.vy = -250
    -- BROWNFIELD: messy globals, no state table
    score = 0
    health = Health.new(3)
    -- TODO: powerup system
    -- TODO: brick system
    -- TODO: level progression
    -- FIXME: collision is hacky
end

function love.update(dt)
    ball:update(dt)
    paddle:update(dt)
    health:update(dt)

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
        ball.x = screenWidth / 2
        ball.y = screenHeight - 60
        ball.vx = 200
        ball.vy = -250
        health:damage(1)

        if health:isDead() then
            -- TODO: game over screen
            ball.vx = 0
            ball.vy = 0
        end
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
    health:draw(10, 50)
    ball:draw()
    paddle:draw()
end

-- BROWNFIELD: dead code
function love.keypressed(key)
    if key == "space" then
        -- TODO: pause
    end
end
