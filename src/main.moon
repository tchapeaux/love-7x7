io.stdout\setvbuf'no'

export grid

gridSize = 9

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

love.mousepressed = (x, y, button) ->
    grid\mousepressed(x, y, button)

love.mousereleased = (x, y, button) ->
    grid\mousereleased(x, y, button)

