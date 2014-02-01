io.stdout\setvbuf'no'

export grid

love.load = ->
    require "grid"
    grid = Grid 7

love.draw = ->
    grid\draw!

love.update = (dt) ->
    grid\update dt

love.keyreleased = (key) ->
    switch key
        when "escape"
            love.event.quit!

love.mousepressed = (x, y, button) ->
    grid\mousepressed(x, y, button)

love.mousereleased = (x, y, button) ->
    grid\mousereleased(x, y, button)

