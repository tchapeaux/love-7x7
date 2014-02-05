require "grid"

export ^

w, h = love.graphics.getWidth!, love.graphics.getHeight!

class Game
    new: (gridSize, @timeLimit=-1, @maxMove=-1, changeGridSize=false) =>
        @grid = Grid gridSize
        @menu = Menu!
        @score = 0
        if love.filesystem.isFile "score.txt"
            score, _ = love.filesystem.read "score.txt"
            score = tonumber score
            @grid.score = score

    update: (dt) =>
        if @menu.active
            @menu\update dt
        else
            @grid\update dt

    draw: =>
        @grid\draw!
        if @menu.active
            love.graphics.setColor {0, 0, 0, 100}
            love.graphics.rectangle "fill", 0, 0, w, h
            @menu\draw!

    resetGrid: (newSize=@grid.size) =>
        if newSize == "up"
            newSize = @grid.size + 1
        if newSize == "down"
            newSize = @grid.size - 1
        score = @grid.score
        @grid = Grid newSize
        @grid.score = score


    mousepressed: (x, y, button) =>
        @grid\mousepressed x, y, button

    mousereleased: (x, y, button) =>
        @grid\mousereleased x, y, button

    keyreleased: (key) =>
        switch key
            when "escape"
                if not @menu.active
                    @menu.active = true
                else
                    @menu\keyreleased key
            when "r"
                unless @menu.active
                    @resetGrid!
            when "up"
                if @menu.active
                    @menu\keyreleased key
                else
                    @resetGrid "up"
            when "down"
                if @menu.active
                    @menu\keyreleased key
                else
                    @resetGrid "down"
            when "f11"
                width, height, fullscreen, vsync, fsaa = love.graphics.getMode!
                love.graphics.setMode width, height, not fullscreen, vsync, fsaa
            else
                if @menu.active
                    @menu\keyreleased key
