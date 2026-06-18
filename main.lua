local Ball = require("src.ball")
local Paddle = require("src.paddle")
local Brick = require("src.brick")

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
    -- TODO: powerup system
    -- TODO: level progression

    bricks = {}
    local cols = 8
    local rows = 5
    local brickWidth = 80
    local brickHeight = 24
    local gap = 4
    local totalWidth = cols * brickWidth + (cols - 1) * gap
    local startX = (screenWidth - totalWidth) / 2
    local startY = 50
    local rowColors = {
        {1, 0, 0, 1},
        {1, 0.5, 0, 1},
        {1, 1, 0, 1},
        {0, 1, 0, 1},
        {0, 0.5, 1, 1},
    }
    for row = 1, rows do
        for col = 1, cols do
            local x = startX + (col - 1) * (brickWidth + gap)
            local y = startY + (row - 1) * (brickHeight + gap)
            local color = rowColors[row] or {1, 1, 1, 1}
            table.insert(bricks, Brick.new(x, y, brickWidth, brickHeight, color))
        end
    end
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
            ball.y = paddle.y - 8
            ball.vy = -math.abs(ball.vy)
        end
    end

    for _, brick in ipairs(bricks) do
        if brick.active then
            if ball.x + 8 >= brick.x and ball.x - 8 <= brick.x + brick.width and
               ball.y + 8 >= brick.y and ball.y - 8 <= brick.y + brick.height then
                ball.vy = -ball.vy
                brick.active = false
                score = score + 10
                break
            end
        end
    end
end

function love.draw()
    love.graphics.print("Atarogue", 10, 10)
    -- BROWNFIELD: magic numbers everywhere
    love.graphics.print("Score: " .. score, 10, 30)
    love.graphics.print("Lives: " .. lives, 10, 50)
    for _, brick in ipairs(bricks) do
        brick:draw()
    end
    ball:draw()
    paddle:draw()
end

-- BROWNFIELD: dead code
function love.keypressed(key)
    if key == "space" then
        -- TODO: pause
    end
end
