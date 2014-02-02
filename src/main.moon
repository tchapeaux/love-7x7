io.stdout\setvbuf'no'

export grid

gridSize = 7

love.load = ->
    require "grid"
    grid = Grid gridSize

love.draw = ->
    grid\draw!

love.update = (dt) ->
    grid\update dt

love.keyreleased = (key) ->
    switch key
        when "escape"
            love.event.quit!
        when "r"
            grid = Grid gridSize
        when "up"
            gridSize += 1
            grid = Grid gridSize
        when "down"
            gridSize -= 1
            grid = Grid gridSize
        when "f11"
            width, height, fullscreen, vsync, fsaa = love.graphics.getMode!
            love.graphics.setMode width, height, not fullscreen, vsync, fsaa

love.mousepressed = (x, y, button) ->
    grid\mousepressed(x, y, button)

love.mousereleased = (x, y, button) ->
    grid\mousereleased(x, y, button)

