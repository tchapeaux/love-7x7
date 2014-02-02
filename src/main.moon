io.stdout\setvbuf'no'

export grid, menu

w, h = love.graphics.getWidth!, love.graphics.getHeight!
gridSize = 7

love.load = ->
    require "grid"
    require "menu"

    font = love.graphics.newFont "res/font/ComicRelief.ttf", 20
    love.graphics.setFont font
    grid = Grid gridSize
    if love.filesystem.isFile "score.txt"
        score, _ = love.filesystem.read "score.txt"
        score = tonumber score
        grid.score = score
    menu = Menu!

love.draw = ->
    grid\draw!
    if menu.active
        love.graphics.setColor {0, 0, 0, 100}
        love.graphics.rectangle "fill", 0, 0, w, h
        menu\draw!

love.update = (dt) ->
    if menu.active
        menu\update dt
    else
        grid\update dt

love.keyreleased = (key) ->
    switch key
        when "escape"
            menu.active = not menu.active
        when "r"
            unless menu.active
                grid = Grid gridSize
        when "up"
            if menu.active
                menu\keyreleased key
            else
                gridSize += 1
                grid = Grid gridSize
        when "down"
            if menu.active
                menu\keyreleased key
            else
                gridSize -= 1
                grid = Grid gridSize
        when "f11"
            width, height, fullscreen, vsync, fsaa = love.graphics.getMode!
            love.graphics.setMode width, height, not fullscreen, vsync, fsaa
        else
            if menu.active
                menu\keyreleased key

love.mousepressed = (x, y, button) ->
    grid\mousepressed(x, y, button)

love.mousereleased = (x, y, button) ->
    grid\mousereleased(x, y, button)

