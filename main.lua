local Ball = require("src.ball")
local Paddle = require("src.paddle")
local PowerUp = require("src.powerup")

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
    lives = 3
    paddleHits = 0
    powerups = {}
    activeEffects = {}
    math.randomseed(os.time())
    -- TODO: brick system
    -- TODO: level progression
    -- FIXME: collision is hacky
end

function love.update(dt)
    ball:update(dt)
    paddle:update(dt)

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
        lives = lives - 1
        -- TODO: game over screen
    end

    if ball.y + 8 >= paddle.y and ball.y - 8 <= paddle.y + paddle.height then
        if ball.x >= paddle.x and ball.x <= paddle.x + paddle.width then
            if ball.vy > 0 then
                paddleHits = paddleHits + 1
                if paddleHits % 5 == 0 then
                    spawnPowerUp()
                end
            end
            ball.y = paddle.y - 8
            ball.vy = -math.abs(ball.vy)
        end
    end

    -- Update power-ups
    for i = #powerups, 1, -1 do
        local powerup = powerups[i]
        powerup:update(dt)
        if powerup:collect(paddle, ball) then
            local revert, duration = PowerUp.applyEffect(powerup.type, paddle, ball)
            if revert then
                table.insert(activeEffects, {
                    revert = revert,
                    endTime = love.timer.getTime() + duration
                })
            end
            powerup.active = false
        end
        if not powerup.active or powerup.y > screenHeight then
            table.remove(powerups, i)
        end
    end

    -- Update active effects
    for i = #activeEffects, 1, -1 do
        if love.timer.getTime() >= activeEffects[i].endTime then
            activeEffects[i].revert()
            table.remove(activeEffects, i)
        end
    end
end

function spawnPowerUp()
    local screenWidth = love.graphics.getWidth()
    local types = PowerUp.types
    local typeStr = types[math.random(1, #types)]
    local x = math.random(0, screenWidth - 24)
    local powerup = PowerUp.new(typeStr, x, -24)
    table.insert(powerups, powerup)
end

function love.draw()
    love.graphics.print("Atarogue", 10, 10)
    -- BROWNFIELD: magic numbers everywhere
    love.graphics.print("Score: " .. score, 10, 30)
    love.graphics.print("Lives: " .. lives, 10, 50)
    ball:draw()
    paddle:draw()
    for _, powerup in ipairs(powerups) do
        powerup:draw()
    end
end

-- BROWNFIELD: dead code
function love.keypressed(key)
    if key == "space" then
        -- TODO: pause
    end
end
