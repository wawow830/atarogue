local Ball = require("src.ball")
local Paddle = require("src.paddle")

local State = {}
State.__index = State

function State.new()
    local self = setmetatable({}, State)

    self.screenWidth = love.graphics.getWidth()
    self.screenHeight = love.graphics.getHeight()

    self.ballRadius = 8
    self.paddleYOffset = 40
    self.ballYOffset = 60
    self.ballInitialVx = 200
    self.ballInitialVy = -250
    self.titleText = "Atarogue"
    self.titleX = 10
    self.titleY = 10
    self.scoreX = 10
    self.scoreY = 30
    self.livesX = 10
    self.livesY = 50
    self.scoreLabel = "Score: "
    self.livesLabel = "Lives: "

    self.paddle = Paddle.new(self.screenWidth / 2 - 40, self.screenHeight - self.paddleYOffset)
    self.ball = Ball.new(self.screenWidth / 2, self.screenHeight - self.ballYOffset)

    self.score = 0
    self.lives = 3
    self.paused = false

    self:resetBall()

    return self
end

function State:resetBall()
    self.ball.x = self.screenWidth / 2
    self.ball.y = self.screenHeight - self.ballYOffset
    self.ball.vx = self.ballInitialVx
    self.ball.vy = self.ballInitialVy
end

function State:reset()
    self.score = 0
    self.lives = 3
    self:resetBall()
end

function State:update(dt)
    if self.paused then
        return
    end

    self.ball:update(dt)
    self.paddle:update(dt)

    -- Clamp paddle to screen bounds
    if self.paddle.x < 0 then
        self.paddle.x = 0
    elseif self.paddle.x + self.paddle.width > self.screenWidth then
        self.paddle.x = self.screenWidth - self.paddle.width
    end

    -- Ball wall bouncing (left, right, top)
    if self.ball.x - self.ballRadius <= 0 then
        self.ball.x = self.ballRadius
        self.ball.vx = math.abs(self.ball.vx)
    elseif self.ball.x + self.ballRadius >= self.screenWidth then
        self.ball.x = self.screenWidth - self.ballRadius
        self.ball.vx = -math.abs(self.ball.vx)
    end

    if self.ball.y - self.ballRadius <= 0 then
        self.ball.y = self.ballRadius
        self.ball.vy = math.abs(self.ball.vy)
    end

    -- Ball falls below screen
    if self.ball.y - self.ballRadius > self.screenHeight then
        self:resetBall()
        self.lives = self.lives - 1
    end

    -- Ball-paddle collision
    if self.ball.y + self.ballRadius >= self.paddle.y
        and self.ball.y - self.ballRadius <= self.paddle.y + self.paddle.height
        and self.ball.x >= self.paddle.x
        and self.ball.x <= self.paddle.x + self.paddle.width then
        self.ball.y = self.paddle.y - self.ballRadius
        self.ball.vy = -math.abs(self.ball.vy)
    end
end

function State:draw()
    love.graphics.print(self.titleText, self.titleX, self.titleY)
    love.graphics.print(self.scoreLabel .. self.score, self.scoreX, self.scoreY)
    love.graphics.print(self.livesLabel .. self.lives, self.livesX, self.livesY)
    self.ball:draw()
    self.paddle:draw()
end

return State
