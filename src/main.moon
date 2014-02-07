io.stdout\setvbuf'no'

export statestack

w, h = love.graphics.getWidth!, love.graphics.getHeight!
gridSize = 7

export lua_mod = (x, m) ->
    -- returns a modulo of x usable with 1-based table
    return ((x - 1) % m) + 1

require "resources"

love.load = ->
    require "statestack"
    require "mainmenu"
    statestack = StateStack!
    statestack\push MainMenu!

current_state = ->
    statestack\peek!

love.draw = ->
    current_state!\draw!

love.update = (dt) ->
    current_state!\update dt

love.keyreleased = (key) ->
    current_state!\keyreleased key

love.mousepressed = (x, y, button) ->
    current_state!\mousepressed(x, y, button)

love.mousereleased = (x, y, button) ->
    current_state!\mousereleased(x, y, button)
