io.stdout\setvbuf'no'

export game

w, h = love.graphics.getWidth!, love.graphics.getHeight!
gridSize = 7

require "resources"

love.load = ->
    require "game"

    font = love.graphics.newFont "res/font/ComicRelief.ttf", 20
    love.graphics.setFont font
    game = Game gridSize

love.draw = ->
    game\draw!

love.update = (dt) ->
    game\update dt

love.keyreleased = (key) ->
    game\keyreleased key

love.mousepressed = (x, y, button) ->
    game\mousepressed(x, y, button)

love.mousereleased = (x, y, button) ->
    game\mousereleased(x, y, button)

