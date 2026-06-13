local Ball = require("src.ball")
local Paddle = require("src.paddle")
local GameOver = require("src.gameover")

function resetGame()
    local screenWidth = love.graphics.getWidth()
    local screenHeight = love.graphics.getHeight()

    paddle = Paddle.new(screenWidth / 2 - 40, screenHeight - 40)
    ball = Ball.new(screenWidth / 2, screenHeight - 60)
    ball.vx = 200
    ball.vy = -250
    score = 0
    lives = 3
    gameState = "playing"
end

function love.load()
    -- Atarogue: a roguelike Atari Breakout
    print("Atarogue loaded!")

    local screenWidth = love.graphics.getWidth()
    local screenHeight = love.graphics.getHeight()

    gameOverScreen = GameOver.new(screenWidth, screenHeight)
    resetGame()
    -- TODO: powerup system
    -- TODO: brick system
    -- TODO: level progression
    -- FIXME: collision is hacky
end

function love.update(dt)
    if gameState ~= "playing" then
        return
    end

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
        lives = lives - 1
        if lives <= 0 then
            gameState = "gameover"
        else
            ball.x = screenWidth / 2
            ball.y = screenHeight - 60
            ball.vx = 200
            ball.vy = -250
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
    love.graphics.print("Lives: " .. lives, 10, 50)
    ball:draw()
    paddle:draw()

    if gameState == "gameover" then
        gameOverScreen:draw()
    end
end

function love.mousepressed(x, y, button)
    if gameState == "gameover" and button == 1 then
        if gameOverScreen:mousepressed(x, y) then
            resetGame()
        end
    end
end

function love.keypressed(key)
    if gameState == "gameover" then
        if gameOverScreen:keypressed(key) then
            resetGame()
        end
    elseif key == "space" then
        -- TODO: pause
    end
end
