local State = require("src.state")

-- TODO: powerup system
-- TODO: brick system
-- TODO: level progression
-- TODO: game over screen

gameState = nil

function love.load()
    print("Atarogue loaded!")
    gameState = State.new()
end

function love.update(dt)
    if not gameState.paused then
        gameState:update(dt)
    end
end

function love.draw()
    if gameState then
        gameState:draw()
    end
end

function love.keypressed(key)
    if key == "space" then
        gameState.paused = not gameState.paused
    end
end
