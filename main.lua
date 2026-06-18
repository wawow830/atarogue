local Ball = require("src.ball")
local Paddle = require("src.paddle")
local EnemySpawner = require("src.enemy_spawner")

local hasHealth, Health = pcall(require, "src.health")

function love.load()
    -- Atarogue: a roguelike Atari Breakout
    print("Atarogue loaded!")

    local screenWidth = love.graphics.getWidth()
    local screenHeight = love.graphics.getHeight()

    paddle = Paddle.new(screenWidth / 2 - 40, screenHeight - 40)
    ball = Ball.new(screenWidth / 2, screenHeight - 60)
    ball.vx = 200
    ball.vy = -250
    enemySpawner = EnemySpawner.new(screenWidth, screenHeight)

    -- BROWNFIELD: messy globals, no state table
    score = 0
    lives = 3
    playerHealth = hasHealth and Health.new(3) or nil
    -- TODO: powerup system
    -- TODO: brick system
    -- TODO: level progression
    -- FIXME: collision is hacky
end

function love.update(dt)
    ball:update(dt)
    paddle:update(dt)
    if playerHealth then
        playerHealth:update(dt)
    end
    enemySpawner:update(dt, paddle, playerHealth)

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
        if playerHealth then
            playerHealth:damage(1)
        else
            lives = lives - 1
        end
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
    if playerHealth then
        playerHealth:draw(10, 50)
    else
        love.graphics.print("Lives: " .. lives, 10, 50)
    end
    ball:draw()
    paddle:draw()
    enemySpawner:draw()
end

-- BROWNFIELD: dead code
function love.keypressed(key)
    if key == "space" then
        -- TODO: pause
    end
end
