export ^

require "game"

class MainMenu
    new: =>
        @w = love.graphics.getWidth!
        @h = love.graphics.getHeight!
        @fontBig = love.graphics.newFont "res/font/ComicRelief.ttf", 100
        @fontMed = love.graphics.newFont "res/font/ComicRelief.ttf", 20
        @title = "PÖINTS"
        @selected = 1
        @text = {
            "Time Mode"
            "Move Mode"
            "Infinite Mode"
        }

        @defaultGridSize = 7

    update: =>


    draw: =>
        love.graphics.setFont @fontBig
        love.graphics.setColor {255, 255, 255}
        love.graphics.printf @title, 0, @h / 8, @w, "center"
        love.graphics.setFont @fontMed
        for i, text in ipairs @text
            if i == @selected
                love.graphics.setColor {255, 255, 255}
            else
                love.graphics.setColor {200, 200, 200}
            love.graphics.printf text, (i-1) * @w / 3, 3 * @h / 4, @w / 3, "center"

    keyreleased: (key) =>
        switch key
            when "right"
                @selected += 1
                @selected = lua_mod @selected, #@text
            when "left"
                @selected -= 1
                @selected = lua_mod @selected, #@text
            when "return"
                @launchGame!
            when "escape"
                love.event.quit!

    launchGame: =>
        gameMode = @text[@selected]
        local game
        if gameMode == "Time Mode"
            game = Game @defaultGridSize, 30
        elseif gameMode == "Move Mode"
            game = Game @defaultGridSize, -1, 30
        elseif gameMode == "Infinite Mode"
            game = Game @defaultGridSize
        else
            error "Invalid game mode: #[gameMode}"
        statestack\push game
