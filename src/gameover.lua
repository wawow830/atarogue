local GameOver = {}
GameOver.__index = GameOver

function GameOver.new(screenWidth, screenHeight)
    local self = setmetatable({}, GameOver)
    self.screenWidth = screenWidth or 800
    self.screenHeight = screenHeight or 600
    self.buttonWidth = 200
    self.buttonHeight = 50
    self.buttonX = self.screenWidth / 2 - self.buttonWidth / 2
    self.buttonY = self.screenHeight / 2 + 40
    return self
end

function GameOver:draw()
    -- Dark overlay
    love.graphics.setColor(0, 0, 0, 0.7)
    love.graphics.rectangle("fill", 0, 0, self.screenWidth, self.screenHeight)

    -- "Game Over" text
    love.graphics.setColor(1, 0, 0, 1)
    local font = love.graphics.getFont()
    local text = "Game Over"
    local textWidth = font:getWidth(text)
    local textHeight = font:getHeight()
    love.graphics.print(text, self.screenWidth / 2 - textWidth / 2, self.screenHeight / 2 - textHeight - 20)

    -- Restart button
    love.graphics.setColor(0.2, 0.2, 0.2, 1)
    love.graphics.rectangle("fill", self.buttonX, self.buttonY, self.buttonWidth, self.buttonHeight)
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.rectangle("line", self.buttonX, self.buttonY, self.buttonWidth, self.buttonHeight)

    local buttonText = "Restart"
    local buttonTextWidth = font:getWidth(buttonText)
    local buttonTextHeight = font:getHeight()
    love.graphics.print(
        buttonText,
        self.buttonX + self.buttonWidth / 2 - buttonTextWidth / 2,
        self.buttonY + self.buttonHeight / 2 - buttonTextHeight / 2
    )

    -- Reset color to white
    love.graphics.setColor(1, 1, 1, 1)
end

function GameOver:isMouseOverButton(mx, my)
    return mx >= self.buttonX and mx <= self.buttonX + self.buttonWidth
        and my >= self.buttonY and my <= self.buttonY + self.buttonHeight
end

function GameOver:mousepressed(mx, my)
    return self:isMouseOverButton(mx, my)
end

function GameOver:keypressed(key)
    return key == "return" or key == "space"
end

return GameOver
