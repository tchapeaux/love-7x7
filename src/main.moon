io.stdout\setvbuf'no'

export statestack

export wScr, hScr
wScr, hScr = love.window.getWidth, love.window.getHeight
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
    if current_state!.draw
        current_state!\draw!

love.update = (dt) ->
    if current_state!.update
        current_state!\update dt

love.keypressed = (key) ->
    if current_state!.keypressed
        current_state!\keypressed key

love.keyreleased = (key) ->
    if current_state!.keyreleased
        current_state!\keyreleased key

love.mousepressed = (x, y, button) ->
    if current_state!.mousepressed
        current_state!\mousepressed(x, y, button)

love.mousereleased = (x, y, button) ->
    if current_state!.mousereleased
        current_state!\mousereleased(x, y, button)
